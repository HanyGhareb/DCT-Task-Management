prompt --application/pages/page_00065
begin
--   Manifest
--     PAGE: 00065
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
 p_id=>65
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Scoping Document Approve / Reject'
,p_alias=>'SCOPING-DOCUMENT-APPROVE-REJECT'
,p_step_title=>'Scoping Document Approve / Reject'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(127761711380449835)
,p_page_template_options=>'#DEFAULT#'
,p_read_only_when_type=>'ALWAYS'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240228233722'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3051749645104382)
,p_plug_name=>'APPENDIX A - SCOPE OF WORK'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285618139823456311)
,p_plug_name=>'APPENDIX A - SCOPE OF WORK'
,p_parent_plug_id=>wwv_flow_api.id(3051749645104382)
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
 p_id=>wwv_flow_api.id(283840436769007761)
,p_plug_name=>'Project Overview'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,1) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285893713356282936)
,p_plug_name=>'Project Overview'
,p_parent_plug_id=>wwv_flow_api.id(283840436769007761)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(149876730128191766)
,p_plug_name=>'DCT_REPRESENTATIVES_AND_SUPPORT REGION'
,p_parent_plug_id=>wwv_flow_api.id(285893713356282936)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(283840710683007764)
,p_plug_name=>'Requirements Overview'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,2) = ''Y'' and 1 =2'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285893775180282937)
,p_plug_name=>'Requirements Overview'
,p_parent_plug_id=>wwv_flow_api.id(283840710683007764)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285768917634302660)
,p_plug_name=>'Enquires and Contact Procedure'
,p_parent_plug_id=>wwv_flow_api.id(285893775180282937)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_plug_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This section is removed as per UAT Session1 on 30-Jan-23 (Tim, Swati, Tamer)',
'Server Side Condition used: DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,41) = ''Y''  '))
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285768979435302661)
,p_plug_name=>'Enquires and Contact Procedure Report'
,p_parent_plug_id=>wwv_flow_api.id(285768917634302660)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       NAME,',
'       POSITION,',
'       EMAIL,',
'       PHONE_NO,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE',
'  from DP_SCOPING_A_ENQUIRES_CONTACT_PROC',
'  where DP_SCOPING_A_ID = :P65_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Enquires and Contact Procedure Report'
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
 p_id=>wwv_flow_api.id(285769228088302663)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Enquires and Contact Procedure available'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:52:&SESSION.::&DEBUG.::P52_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>429971397062358627
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3461253042947782)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3461714357947782)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3462125230947782)
,p_db_column_name=>'NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3462445595947782)
,p_db_column_name=>'POSITION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Position'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3462928537947782)
,p_db_column_name=>'EMAIL'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3463271459947783)
,p_db_column_name=>'PHONE_NO'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Phone No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3463701823947783)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3464037592947783)
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
 p_id=>wwv_flow_api.id(3464517767947783)
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
 p_id=>wwv_flow_api.id(3464868010947783)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(285807414693057343)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1476674'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'NAME:POSITION:EMAIL:PHONE_NO:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285795719008072125)
,p_plug_name=>'Objectives and Benefits to DCT'
,p_parent_plug_id=>wwv_flow_api.id(285893775180282937)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,61) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285795869943072127)
,p_plug_name=>'Objectives and Benefits to DCT Report'
,p_parent_plug_id=>wwv_flow_api.id(285795719008072125)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       RECORD_TYPE,',
'       DESCRIPTION,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'       DELETED_FLAG',
'  from DP_SCOPING_A_OBJECTIVES_BENEFITS',
'  where DP_SCOPING_A_ID = :P65_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Objectives and Benefits to DCT Report'
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
 p_id=>wwv_flow_api.id(285795990300072128)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Objectives and Benefits to DCT available'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.::P55_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>429998159274128092
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3466673700947789)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3467090006947789)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3467499338947789)
,p_db_column_name=>'RECORD_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Objective / Benefit'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(144021439796014080)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3467894124947790)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3468285442947790)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3468638334947790)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3469114488947790)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3469434278947790)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3469919406947791)
,p_db_column_name=>'DELETED_FLAG'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Deleted Flag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(285817829053018277)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1476724'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'RECORD_TYPE:DESCRIPTION:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(283841051834007768)
,p_plug_name=>'Timelines'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,3) = ''Y'' and',
'(:P65_EXPECTED_START_DATE is not null or ',
':P65_EXPECTED_END_DATE is not null or ',
':P65_TENDER_START_DATE is not null or ',
':P65_EXPECTED_CONTRACT_START_DATE is not null or ',
':P65_DURATION_COMMENTS is not null)'))
,p_plug_read_only_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_read_only_when=>'IS_PBP_EMP'
,p_plug_read_only_when2=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285893904932282938)
,p_plug_name=>'Timelines'
,p_parent_plug_id=>wwv_flow_api.id(283841051834007768)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'ALWAYS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285746895365341722)
,p_plug_name=>'Submission Information'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,4) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285747326098341726)
,p_plug_name=>'Scope of Services'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,5) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(150688770352108088)
,p_plug_name=>'Guidance'
,p_parent_plug_id=>wwv_flow_api.id(285747326098341726)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(150688967162108090)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(285747326098341726)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285747682512341730)
,p_plug_name=>'Required Deliverables'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,6) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285797320352072141)
,p_plug_name=>'Required Deliverables Report'
,p_parent_plug_id=>wwv_flow_api.id(285747682512341730)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       DELIVERABLE_DESCRIPTION,',
'       DELIVERABLE_WEIGHT,',
'       DATE_DEFINED_YN,',
'       MILESTONE_DUE_DATE,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'        FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from DP_SCOPING_A_DELIVERABLES',
'  where DP_SCOPING_A_ID = :P65_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Required Deliverables Report'
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
 p_id=>wwv_flow_api.id(285797427639072142)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Deliverables Available.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_control_break=>'N'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.::P33_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P65_REVIEW_STATUS  in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>429999596613128106
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3513107868947818)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3513455816947819)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3513869473947819)
,p_db_column_name=>'DELIVERABLE_DESCRIPTION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Deliverable Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3514299072947819)
,p_db_column_name=>'DELIVERABLE_WEIGHT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3514727241947819)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3515045094947819)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3515515058947820)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3515903357947820)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3509438378947817)
,p_db_column_name=>'FILENAME'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3509886259947817)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3510298257947817)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3510663641947817)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3511129985947818)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'File Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3511486300947818)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3511871387947818)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:DP_SCOPING_A_DELIVERABLES:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:FILE_UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3512255806947818)
,p_db_column_name=>'DATE_DEFINED_YN'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Milestone Defined ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3512717807947818)
,p_db_column_name=>'MILESTONE_DUE_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Milestone Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(285836462878207062)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1477184'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DELIVERABLE_DESCRIPTION:DATE_DEFINED_YN:MILESTONE_DUE_DATE:FILENAME:FILE_COMMENTS:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285748095201341734)
,p_plug_name=>'Performance Measurements'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,7) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285798489918072153)
,p_plug_name=>'Performance Measurements Report'
,p_parent_plug_id=>wwv_flow_api.id(285748095201341734)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select KPI_ID,',
'       DP_SCOPING_A_ID,',
'       KPI_NAME,',
'       KPI_DESCRIPTION,',
'       TARGET_VALUE,',
'       TARGET_DATE,',
'       TREND_DIRECTION,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'       METHOD_OF_MEASURE,',
'       SERVICE_CREDIT',
'  from DP_SCOPING_A_KPI',
'  where DP_SCOPING_A_ID = :P65_SCOPE_ID',
'  order by KPI_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Performance Measurements Report'
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
 p_id=>wwv_flow_api.id(285798607684072154)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Performance Measurements available.'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:34:P34_KPI_ID:#KPI_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>430000776658128118
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
 p_id=>wwv_flow_api.id(3519701429947822)
,p_db_column_name=>'KPI_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Kpi Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3520081306947822)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3520493263947823)
,p_db_column_name=>'KPI_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'KPI Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3520879939947823)
,p_db_column_name=>'KPI_DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3521308451947823)
,p_db_column_name=>'TARGET_VALUE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Target Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3521672619947823)
,p_db_column_name=>'TARGET_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Target Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3522126536947823)
,p_db_column_name=>'TREND_DIRECTION'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Trend Direction'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3522512948947823)
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
 p_id=>wwv_flow_api.id(3522886699947824)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3523329314947824)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3523728751947824)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3518845792947822)
,p_db_column_name=>'METHOD_OF_MEASURE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Method Of Measure'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3519290037947822)
,p_db_column_name=>'SERVICE_CREDIT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Service Credit'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(285845292727181508)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1477262'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'KPI_NAME:KPI_DESCRIPTION:METHOD_OF_MEASURE:SERVICE_CREDIT:TARGET_VALUE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285748530098341738)
,p_plug_name=>'Supplier Responsibilities'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,8) = ''Y'' and 1 =2'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285799786724072166)
,p_plug_name=>'Supplier Responsibilities Report'
,p_parent_plug_id=>wwv_flow_api.id(285748530098341738)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       RESPONSIBILITY_NAME,',
'       RESPONSIBILITY_DATE,',
'       DFF1,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE',
'  from DP_SCOPING_A_SUPPLIER_RESP',
'  where DP_SCOPING_A_ID = :P65_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Supplier Responsibilities Report'
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
 p_id=>wwv_flow_api.id(285799900572072167)
,p_max_row_count=>'1000000'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:35:P35_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>430002069546128131
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3472842271947793)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3473240472947793)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3473706619947793)
,p_db_column_name=>'RESPONSIBILITY_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Responsibility Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3474109175947793)
,p_db_column_name=>'RESPONSIBILITY_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Responsibility Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3474435999947793)
,p_db_column_name=>'DFF1'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Dff1'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3474884092947793)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3475232597947794)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3475657255947794)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3476052144947794)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(285855283536160553)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1476786'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'RESPONSIBILITY_NAME:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285748868020341742)
,p_plug_name=>'Proposal Submission Requirements'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,9) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285846808213173428)
,p_plug_name=>'Proposal Submission Requirements Report'
,p_parent_plug_id=>wwv_flow_api.id(285748868020341742)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       REQUIREMENT_NAME,',
'       REQUIREMENT_DESC,',
'       REQUIREMENT_TARGET,',
'       REQUIREMENT_DATE,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE',
'  from DP_SCOPING_A_PROPOSAL_SUBMISSION_REQ',
'  where DP_SCOPING_A_ID = :P65_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Proposal Submission Requirements Report'
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
 p_id=>wwv_flow_api.id(285846855976173429)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'Noting Available'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:36:P36_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>430049024950229393
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3479118428947796)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3479514993947796)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3479840650947796)
,p_db_column_name=>'REQUIREMENT_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Requirement Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3480264480947797)
,p_db_column_name=>'REQUIREMENT_DESC'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3480650464947797)
,p_db_column_name=>'REQUIREMENT_TARGET'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Requirement Target'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3481033360947797)
,p_db_column_name=>'REQUIREMENT_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Requirement Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3481472382947797)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3481838467947797)
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
 p_id=>wwv_flow_api.id(3482282770947797)
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
 p_id=>wwv_flow_api.id(3482730463947798)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(285867768111053586)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1476852'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUIREMENT_NAME:REQUIREMENT_DESC:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285749345322341746)
,p_plug_name=>'Security Requirements'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>100
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,10) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285848139622173441)
,p_plug_name=>'Security Requirements Report'
,p_parent_plug_id=>wwv_flow_api.id(285749345322341746)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       SECURITY_REQ,',
'       PRIORITY,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE',
'  from DP_SCOPING_A_SECURITY_REQ',
'  where DP_SCOPING_A_ID =  :P65_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Security Requirements Report'
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
 p_id=>wwv_flow_api.id(285848146941173442)
,p_max_row_count=>'1000000'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.:37:P37_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>430050315915229406
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3485668116947800)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3486108239947800)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3486466240947800)
,p_db_column_name=>'SECURITY_REQ'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Security Requirement'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3486880824947800)
,p_db_column_name=>'PRIORITY'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(128341720324489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3487303086947801)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3487658602947801)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3488069602947801)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3488530436947801)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(285871292393037131)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1476910'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECURITY_REQ:PRIORITY:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285749698227341750)
,p_plug_name=>'Data Capture Requirements'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>110
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,11) = ''Y'' and 1 =2'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285849227872173452)
,p_plug_name=>'Data Capture Requirements Report'
,p_parent_plug_id=>wwv_flow_api.id(285749698227341750)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       DATA_REQUIREMENT,',
'       DESCRIPTIONS,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE',
'  from DP_SCOPING_A_DATA_CAPTURE_REQ',
'  where DP_SCOPING_A_ID = :P65_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Data Capture Requirements Report'
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
 p_id=>wwv_flow_api.id(285849261771173453)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Data Capture Requirements Defined'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.:38:P38_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>430051430745229417
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3491496634947803)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3491905650947803)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3492322673947803)
,p_db_column_name=>'DATA_REQUIREMENT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Data Requirement'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3492662202947803)
,p_db_column_name=>'DESCRIPTIONS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3493095797947804)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3493491251947804)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3493917481947804)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3494298266947808)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(285875354686990553)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1476968'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_A_ID:DATA_REQUIREMENT:DESCRIPTIONS:CREATED_BY:CREATION_DATE:UPDATED_BY:UPDATED_DATE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285750143276341754)
,p_plug_name=>'Intellectual Property/Copyrights of Work'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>120
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,12) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285750451117341758)
,p_plug_name=>'Reporting & Communication Requirements'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>130
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,13) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285750878607341762)
,p_plug_name=>'Added Value Offerings'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>140
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,14) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285751274636341766)
,p_plug_name=>'Attachments and Supporting Documents'
,p_parent_plug_id=>wwv_flow_api.id(285618139823456311)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>150
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P65_TEMPLATE_ID,15) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(414523003294983840)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(285751274636341766)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(414629290952549307)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(414523003294983840)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       SCOPING_ID,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       SCOPING_APPENDIX,',
'       SCOPING_COMPONENT,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       COMMENT_ID,',
'      sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from DP_SCOPING_DOCUMENTS',
'  where SCOPING_ID = :P65_SCOPE_ID',
'    order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(414629433111549308)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>558831602085605272
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3541254936947846)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3541653156947846)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3542031309947847)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::P56_ID,P56_PAGE_FROM:#ID#,28'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3542467776947847)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3542908642947847)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3543242109947847)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3543716746947847)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3544100473947848)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3544520905947848)
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
 p_id=>wwv_flow_api.id(3544905349947848)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3545237180947848)
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
 p_id=>wwv_flow_api.id(3545694951947848)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3546048908947849)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3546456861947849)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3546837050947849)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:DP_SCOPING_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540073195947845)
,p_db_column_name=>'SCOPING_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Scoping Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540492997947846)
,p_db_column_name=>'SCOPING_APPENDIX'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Scoping Appendix'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540917407947846)
,p_db_column_name=>'SCOPING_COMPONENT'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Scoping Component'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(414654945815264475)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1477494'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288095837953098754)
,p_plug_name=>'Demand Planning Item Details'
,p_parent_plug_id=>wwv_flow_api.id(3051749645104382)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3051924180104383)
,p_plug_name=>'APPENDIX B - TECHNICAL EVALUATION CRITERIA'
,p_icon_css_classes=>'fa-bold'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285868146264569335)
,p_plug_name=>'APPENDIX B - TECHNICAL EVALUATION CRITERIA'
,p_parent_plug_id=>wwv_flow_api.id(3051924180104383)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127776395121449810)
,p_plug_display_sequence=>160
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(286011509169415658)
,p_plug_name=>'Technical Criteria - Compliance with SOW'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 16  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288780654633709767)
,p_plug_name=>'Technical Criteria 1 - Compliance with SOW Report'
,p_parent_plug_id=>wwv_flow_api.id(286011509169415658)
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
'    where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_16',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_16,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(288780789524709768)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Compliance with SOW Added.'
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
,p_internal_uid=>432982958498765732
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3758644979060872)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3759119192060872)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3759522507060872)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3759927610060873)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3760323809060873)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3760674939060873)
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
 p_id=>wwv_flow_api.id(3761112909060873)
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
 p_id=>wwv_flow_api.id(3761459525060873)
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
 p_id=>wwv_flow_api.id(3761898304060874)
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
 p_id=>wwv_flow_api.id(3762259291060874)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3762688424060874)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3758321563060872)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(288886162769291660)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479652'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(286011623824415659)
,p_plug_name=>'Technical Criteria - Concept and Program Development  '
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 17  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288783019633709791)
,p_plug_name=>'Technical Criteria - Concept and Program Development Report'
,p_parent_plug_id=>wwv_flow_api.id(286011623824415659)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_17',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_17,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(288783113400709792)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Concept and Program Development  Added'
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
,p_internal_uid=>432985282374765756
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3764922749060875)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3765273928060876)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3765719725060876)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3766035308060876)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3766448003060876)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3766929429060876)
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
 p_id=>wwv_flow_api.id(3767256922060877)
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
 p_id=>wwv_flow_api.id(3767639604060877)
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
 p_id=>wwv_flow_api.id(3768070619060877)
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
 p_id=>wwv_flow_api.id(3768508216060877)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3768895509060877)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3764489413060875)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(288919653286921055)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479714'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(286011879873415661)
,p_plug_name=>'Technical Criteria 3- Agency''s Experience '
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 18  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288938861954036958)
,p_plug_name=>'Technical Criteria - Agency''s Experience'
,p_parent_plug_id=>wwv_flow_api.id(286011879873415661)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_18',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID,P65_TEMPLATE_COMPOENET_ID_18'
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
 p_id=>wwv_flow_api.id(288938936296036959)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria 3- Agency''s Experience  Added.'
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
,p_internal_uid=>433141105270092923
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3771054019060879)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3771489820060879)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3771923852060879)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3772237151060879)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3772697917060880)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3773084156060880)
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
 p_id=>wwv_flow_api.id(3773499259060880)
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
 p_id=>wwv_flow_api.id(3773870798060880)
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
 p_id=>wwv_flow_api.id(3774251247060880)
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
 p_id=>wwv_flow_api.id(3774637232060881)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3775045136060881)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3770637993060879)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289109507472648064)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479776'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(286012031828415663)
,p_plug_name=>'Technical Criteria  - Methodology and Technical Approach'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 19  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288940315190036973)
,p_plug_name=>'Technical Criteria - Methodology and Technical Approach Report'
,p_parent_plug_id=>wwv_flow_api.id(286012031828415663)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_19',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_19,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(288940456033036974)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria  - Methodology and Technical Approach Added.'
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
,p_internal_uid=>433142625007092938
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
 p_id=>wwv_flow_api.id(3777286986060882)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3777663125060883)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3778099665060883)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3778511266060883)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3778890279060883)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3779287231060883)
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
 p_id=>wwv_flow_api.id(3779687963060884)
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
 p_id=>wwv_flow_api.id(3780127196060884)
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
 p_id=>wwv_flow_api.id(3780512340060884)
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
 p_id=>wwv_flow_api.id(3780866944060884)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3781240617060884)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3776929710060882)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289110170729647817)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479838'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(286012281586415665)
,p_plug_name=>'Technical Criteria  - Other Considerations'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 20  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288941856057036988)
,p_plug_name=>'Technical Criteria 5 - Other Considerations Report'
,p_parent_plug_id=>wwv_flow_api.id(286012281586415665)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_20',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_20,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(288941913864036989)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria  - Other Considerations Added.'
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
,p_internal_uid=>433144082838092953
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3783482740060888)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3783897183060888)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3784284619060890)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3784683840060890)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3785101137060890)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3785462752060890)
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
 p_id=>wwv_flow_api.id(3785838562060891)
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
 p_id=>wwv_flow_api.id(3786301111060891)
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
 p_id=>wwv_flow_api.id(3786693497060891)
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
 p_id=>wwv_flow_api.id(3787070393060891)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3787434737060891)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3783062827060887)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289110746546647578)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479900'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288943114995037001)
,p_plug_name=>'Technical Criteria - Corporate experience and resources'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 81  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288943431101037004)
,p_plug_name=>'Technical Criteria - Corporate experience and resources Report'
,p_parent_plug_id=>wwv_flow_api.id(288943114995037001)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_81',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_81,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(288943573839037005)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Technical Criteria - Corporate experience and resources Added.'
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
,p_internal_uid=>433145742813092969
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3789645704060893)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3790103140060893)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3790434302060893)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3790876544060894)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3791326559060894)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3791681682060894)
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
 p_id=>wwv_flow_api.id(3792110285060894)
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
 p_id=>wwv_flow_api.id(3792459110060894)
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
 p_id=>wwv_flow_api.id(3792923636060895)
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
 p_id=>wwv_flow_api.id(3793319838060895)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3793681759060895)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3789312856060893)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289111366616647339)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479962'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288959642542991867)
,p_plug_name=>'Technical Criteria - Management approach'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 82  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288959911379991870)
,p_plug_name=>'Technical Criteria - Management approach Report'
,p_parent_plug_id=>wwv_flow_api.id(288959642542991867)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_82',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_82,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(288960100654991871)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Management approach Added.'
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
,p_internal_uid=>433162269629047835
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3795881970060897)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3796266903060897)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3796635349060897)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3797079321060897)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3797498174060897)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3797874366060897)
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
 p_id=>wwv_flow_api.id(3798297449060898)
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
 p_id=>wwv_flow_api.id(3798674573060898)
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
 p_id=>wwv_flow_api.id(3799120634060898)
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
 p_id=>wwv_flow_api.id(3799488145060898)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3799866816060898)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3795438379060896)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289111960440647099)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1480024'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288961283428991883)
,p_plug_name=>'Technical Criteria - Project Solution'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 83  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288961537103991886)
,p_plug_name=>'Technical Criteria - Project Solution Report'
,p_parent_plug_id=>wwv_flow_api.id(288961283428991883)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_83',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_83,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(288961634621991887)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Project Solution Added'
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
,p_internal_uid=>433163803596047851
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3802129156060900)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3802512972060900)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3802901953060900)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3803236027060901)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3803679200060901)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3804057977060901)
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
 p_id=>wwv_flow_api.id(3804461357060902)
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
 p_id=>wwv_flow_api.id(3804841926060902)
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
 p_id=>wwv_flow_api.id(3805232542060902)
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
 p_id=>wwv_flow_api.id(3805695951060902)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3806104593060902)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3801716066060900)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289112512970646859)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1480086'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288962891777991899)
,p_plug_name=>'Technical Criteria - Detailed project plan, timeline and deliverables, to include quality assurance program'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 84  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288963136060991902)
,p_plug_name=>'Technical Criteria - Detailed project plan, timeline and deliverables, to include quality assurance program Report'
,p_parent_plug_id=>wwv_flow_api.id(288962891777991899)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_84',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_84,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(288963292537991903)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Detailed project plan, timeline and deliverables, to include quality assurance program Added.'
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
,p_internal_uid=>433165461512047867
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3808304906060904)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3808638359060904)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3809117007060904)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3809477118060904)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3809851406060905)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3810330519060905)
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
 p_id=>wwv_flow_api.id(3810633687060905)
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
 p_id=>wwv_flow_api.id(3811114754060905)
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
 p_id=>wwv_flow_api.id(3811462928060906)
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
 p_id=>wwv_flow_api.id(3811882017060906)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3812286075060906)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3807921017060904)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289113153131646613)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1480148'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288979722366952165)
,p_plug_name=>'Technical Criteria - Project completion'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>100
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 85  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288980084125952168)
,p_plug_name=>'Technical Criteria - Project completion report report'
,p_parent_plug_id=>wwv_flow_api.id(288979722366952165)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_85',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_85,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(288980146079952169)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Project completion Added'
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
,p_internal_uid=>433182315054008133
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3814522446060907)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3814848228060908)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3815309113060908)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3815672433060908)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3816107365060908)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3816528232060908)
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
 p_id=>wwv_flow_api.id(3816913674060909)
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
 p_id=>wwv_flow_api.id(3817270886060909)
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
 p_id=>wwv_flow_api.id(3817651880060909)
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
 p_id=>wwv_flow_api.id(3818115898060911)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3818491571060911)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3814099282060907)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289113781790646373)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1480210'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288981345016952181)
,p_plug_name=>'Technical Criteria - Innovation'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>110
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 86  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288981686423952184)
,p_plug_name=>'Technical Criteria - Innovation report'
,p_parent_plug_id=>wwv_flow_api.id(288981345016952181)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_86',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_86,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(288981750758952185)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Innovation Added.'
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
,p_internal_uid=>433183919733008149
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3820698021060912)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3821055565060913)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3821513385060913)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3821853383060913)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3822280662060913)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3822654187060913)
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
 p_id=>wwv_flow_api.id(3823081312060914)
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
 p_id=>wwv_flow_api.id(3823477696060914)
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
 p_id=>wwv_flow_api.id(3823840230060914)
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
 p_id=>wwv_flow_api.id(3824287610060914)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3824684331060914)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3820260896060912)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289114304758646131)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1480272'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288982953847952197)
,p_plug_name=>'Technical Criteria - Knowledge Transfer'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>120
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 87  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(288983212328952200)
,p_plug_name=>'Technical Criteria - Knowledge Transfer report'
,p_parent_plug_id=>wwv_flow_api.id(288982953847952197)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_87',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_87,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(288983365399952201)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Knowledge Transfer Added.'
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
,p_internal_uid=>433185534374008165
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3826906806060916)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3827281826060916)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3827719364060916)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3828089588060917)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3828469056060917)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3828881869060917)
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
 p_id=>wwv_flow_api.id(3829304672060917)
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
 p_id=>wwv_flow_api.id(3829693880060917)
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
 p_id=>wwv_flow_api.id(3830127002060918)
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
 p_id=>wwv_flow_api.id(3830467279060918)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3830881093060918)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3826505751060916)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289114982985645889)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1480334'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289001533403924763)
,p_plug_name=>'Technical Criteria - Stakeholder Engagement and Communication'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>130
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 88  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289001836018924766)
,p_plug_name=>'Technical Criteria - Stakeholder Engagement and Communication report'
,p_parent_plug_id=>wwv_flow_api.id(289001533403924763)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_88',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_88,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(289001976957924767)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Stakeholder Engagement and Communication Added.'
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
,p_internal_uid=>433204145931980731
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3833059572060920)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3833479209060920)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3833840704060920)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3834268077060921)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3834715598060921)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3835110664060921)
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
 p_id=>wwv_flow_api.id(3835445863060921)
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
 p_id=>wwv_flow_api.id(3835843665060921)
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
 p_id=>wwv_flow_api.id(3836247132060922)
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
 p_id=>wwv_flow_api.id(3836634395060922)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3837121101060922)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3832665226060920)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289115547431645642)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1480396'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289003125586924779)
,p_plug_name=>'Technical Criteria - Social and Environmental Value'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>140
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 89  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289003492271924782)
,p_plug_name=>'Technical Criteria - Social and Environmental Value report'
,p_parent_plug_id=>wwv_flow_api.id(289003125586924779)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_89',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_89,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(289003595791924783)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Social and Environmental Value Added.'
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
,p_internal_uid=>433205764765980747
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3684343499060805)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3684751452060813)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3685170701060813)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3685585793060814)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3686006371060814)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3686362304060814)
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
 p_id=>wwv_flow_api.id(3686804257060814)
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
 p_id=>wwv_flow_api.id(3687136827060814)
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
 p_id=>wwv_flow_api.id(3687576185060815)
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
 p_id=>wwv_flow_api.id(3688012883060815)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3688415314060815)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3683940812060795)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289116194454645403)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1478909'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289004769079924795)
,p_plug_name=>'Technical Criteria - Value added features'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>150
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 90  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289005030261924798)
,p_plug_name=>'Technical Criteria - Value added features report'
,p_parent_plug_id=>wwv_flow_api.id(289004769079924795)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_90',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_90,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(289005158539924799)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Value added features Added.'
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
,p_internal_uid=>433207327513980763
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3690581801060817)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3690960029060817)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3691387583060817)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3691740734060817)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3692174059060817)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3692533632060817)
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
 p_id=>wwv_flow_api.id(3692958373060818)
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
 p_id=>wwv_flow_api.id(3693353778060818)
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
 p_id=>wwv_flow_api.id(3693797339060818)
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
 p_id=>wwv_flow_api.id(3694230780060818)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3694536072060818)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3690142094060816)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289116771514645161)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1478971'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289020728354905361)
,p_plug_name=>'Technical Criteria - Proof-of-Concept / Sample / Solution / Presentation'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>160
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 91  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289021021053905364)
,p_plug_name=>'Technical Criteria - Value added features report'
,p_parent_plug_id=>wwv_flow_api.id(289020728354905361)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_91',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_91,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(289021122298905365)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Proof-of-Concept / Sample / Solution / Presentation.'
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
,p_internal_uid=>433223291272961329
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3696771411060820)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3697189770060820)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3697555020060820)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3697946692060821)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3698382447060821)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3698748747060821)
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
 p_id=>wwv_flow_api.id(3699182934060821)
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
 p_id=>wwv_flow_api.id(3699596066060821)
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
 p_id=>wwv_flow_api.id(3699931825060821)
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
 p_id=>wwv_flow_api.id(3700341469060822)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3700796267060822)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3696342744060820)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289117326455644922)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479033'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289022399924905377)
,p_plug_name=>'Technical Criteria - Company Overview and Management Approach'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>170
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 92  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289022668006905380)
,p_plug_name=>'Technical Criteria - Company Overview and Management Approach report'
,p_parent_plug_id=>wwv_flow_api.id(289022399924905377)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_92',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_92,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(289022790622905381)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Company Overview and Management Approach Added.'
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
,p_internal_uid=>433224959596961345
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3702933994060823)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3703335231060824)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3703829765060824)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3704176980060824)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3704572147060824)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3705023137060824)
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
 p_id=>wwv_flow_api.id(3705357603060825)
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
 p_id=>wwv_flow_api.id(3705769387060825)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
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
 p_id=>wwv_flow_api.id(3706154641060825)
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
 p_id=>wwv_flow_api.id(3706569915060825)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3706973441060825)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3702627187060823)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289117985108644681)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479095'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289023988397905393)
,p_plug_name=>'Technical Criteria - Program Management and Concept'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>180
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 93  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289024295344905396)
,p_plug_name=>'Technical Criteria - Program Management and Concept report'
,p_parent_plug_id=>wwv_flow_api.id(289023988397905393)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_93',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_93,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(289024381971905397)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Program Management and Concept Added.'
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
,p_internal_uid=>433226550945961361
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3709228670060838)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3709618985060838)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3709987111060838)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3710364265060838)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3710812147060838)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3711168124060839)
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
 p_id=>wwv_flow_api.id(3711542982060839)
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
 p_id=>wwv_flow_api.id(3711972744060839)
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
 p_id=>wwv_flow_api.id(3712395763060839)
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
 p_id=>wwv_flow_api.id(3712778345060839)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3713173631060840)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3708830664060837)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289118510807644438)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479157'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289042836821798659)
,p_plug_name=>'Technical Criteria - Business Requirement Compliance'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>190
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 94  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289043179152798662)
,p_plug_name=>'Technical Criteria - Business Requirement Compliance report'
,p_parent_plug_id=>wwv_flow_api.id(289042836821798659)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_94',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_94,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(289043243176798663)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Business Requirement Compliance Added.'
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
,p_internal_uid=>433245412150854627
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3715361151060841)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3715769263060841)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3716184152060841)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3716628396060842)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3717004509060842)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3717369817060842)
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
 p_id=>wwv_flow_api.id(3717737748060842)
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
 p_id=>wwv_flow_api.id(3718213404060842)
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
 p_id=>wwv_flow_api.id(3718608596060845)
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
 p_id=>wwv_flow_api.id(3718991074060845)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3719349868060845)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3714984648060841)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289119106484644198)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479219'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289044421350798675)
,p_plug_name=>'Technical Criteria - Technical Capability (Qualitative)'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>200
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 96  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289044716314798678)
,p_plug_name=>'Technical Criteria - Technical Capability (Qualitative) report'
,p_parent_plug_id=>wwv_flow_api.id(289044421350798675)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_96',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_96,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(289044864705798679)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Technical Capability (Qualitative) Added.'
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
,p_internal_uid=>433247033679854643
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3721579376060847)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3722017714060847)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3722411154060847)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3722739459060848)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3723131549060848)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3723543323060848)
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
 p_id=>wwv_flow_api.id(3723936901060848)
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
 p_id=>wwv_flow_api.id(3724387944060848)
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
 p_id=>wwv_flow_api.id(3724746679060848)
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
 p_id=>wwv_flow_api.id(3725168405060849)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3725584930060849)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3721167834060847)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289119791507643939)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479281'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289046027893798691)
,p_plug_name=>'Technical Criteria - Technical Capability (Quantitative)'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>210
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 97  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289046318103798694)
,p_plug_name=>'Technical Criteria - Technical Capability (Quantitative) report'
,p_parent_plug_id=>wwv_flow_api.id(289046027893798691)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_97',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_97,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(289046426049798695)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Technical Capability (Quantitative) Added.'
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
,p_internal_uid=>433248595023854659
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3727755349060850)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3728164769060851)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3728532729060851)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3729008942060851)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3729402407060851)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3729785852060851)
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
 p_id=>wwv_flow_api.id(3730183876060851)
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
 p_id=>wwv_flow_api.id(3730554273060852)
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
 p_id=>wwv_flow_api.id(3731010065060852)
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
 p_id=>wwv_flow_api.id(3731402383060852)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3731780170060852)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3727406482060850)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289120372283643681)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479343'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289067380206765157)
,p_plug_name=>'Technical Criteria - Team Capability'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>220
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 98  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289067930038765163)
,p_plug_name=>'Technical Criteria - Technical Criteria - Team Capability Report'
,p_parent_plug_id=>wwv_flow_api.id(289067380206765157)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_98',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_98,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(289068071661765164)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Team Capability Added.'
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
,p_internal_uid=>433270240635821128
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3733973870060856)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3734394951060856)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3734822307060856)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3735107478060856)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3735512389060857)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3735903554060857)
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
 p_id=>wwv_flow_api.id(3736315191060857)
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
 p_id=>wwv_flow_api.id(3736651402060857)
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
 p_id=>wwv_flow_api.id(3737100939060857)
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
 p_id=>wwv_flow_api.id(3737466108060858)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3737868888060858)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3733571997060855)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289121032179643445)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479404'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289067627132765160)
,p_plug_name=>'Technical Criteria - Reporting and Delivery'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>230
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 99  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289069219037765176)
,p_plug_name=>'Technical Criteria - Reporting and Delivery Report'
,p_parent_plug_id=>wwv_flow_api.id(289067627132765160)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_99',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_99,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(289069398076765177)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Reporting and Delivery Added.'
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
,p_internal_uid=>433271567050821141
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3740117893060859)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3740506965060860)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3740895354060860)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3741278712060860)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3741667900060860)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3742041930060861)
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
 p_id=>wwv_flow_api.id(3742502275060861)
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
 p_id=>wwv_flow_api.id(3742913834060861)
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
 p_id=>wwv_flow_api.id(3743275077060863)
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
 p_id=>wwv_flow_api.id(3743709112060863)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3744055824060864)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3739714838060859)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289121639098643209)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479466'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289070575178765189)
,p_plug_name=>'Technical Criteria - Vendor Performance'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>240
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 100 ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289070808215765192)
,p_plug_name=>'Technical Criteria - Vendor Performance Report'
,p_parent_plug_id=>wwv_flow_api.id(289070575178765189)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_100',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_100,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(289070901561765193)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Vendor Performance Added.'
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
,p_internal_uid=>433273070535821157
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3746278082060865)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3746703887060865)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3747090138060866)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3747511800060866)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3747833132060866)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3748326505060866)
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
 p_id=>wwv_flow_api.id(3748646352060866)
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
 p_id=>wwv_flow_api.id(3749079656060867)
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
 p_id=>wwv_flow_api.id(3749519745060867)
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
 p_id=>wwv_flow_api.id(3749904770060867)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3750310517060867)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3745870317060865)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289122253653642974)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479528'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289072145268765205)
,p_plug_name=>'Technical Criteria - Tourism Experience and Resources'
,p_parent_plug_id=>wwv_flow_api.id(285868146264569335)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>250
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P65_TEMPLATE_ID  , 101 ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289088164983722958)
,p_plug_name=>'Technical Criteria - Tourism Experience and Resources Report'
,p_parent_plug_id=>wwv_flow_api.id(289072145268765205)
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
'  where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_101',
'  and DP_SCOPING_B_ID = :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_TEMPLATE_COMPOENET_ID_101,P65_DP_ITEM_ID,P65_TEMPLATE_ID,P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(289088264747722959)
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'No Technical Criteria - Tourism Experience and Resources Added.'
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
,p_internal_uid=>433290433721778923
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3752497942060869)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3752907570060869)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3753254789060869)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3753651392060869)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3754104211060869)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3754470196060870)
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
 p_id=>wwv_flow_api.id(3754912827060870)
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
 p_id=>wwv_flow_api.id(3755283628060870)
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
 p_id=>wwv_flow_api.id(3755668488060870)
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
 p_id=>wwv_flow_api.id(3756112267060870)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3756479092060871)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3752097231060868)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289122801127642732)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1479590'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3052000782104384)
,p_plug_name=>'APPENDIX C - COMMERCIAL EVALUATION CRITERIA'
,p_icon_css_classes=>'fa-copyright'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(286043093326668960)
,p_plug_name=>'APPENDIX C - COMMERCIAL EVALUATION CRITERIA'
,p_parent_plug_id=>wwv_flow_api.id(3052000782104384)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127776395121449810)
,p_plug_display_sequence=>260
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(286183274497515295)
,p_plug_name=>'Commercial Criterion'
,p_parent_plug_id=>wwv_flow_api.id(286043093326668960)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''C'' , :P65_TEMPLATE_ID  , 21  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(289260462054822601)
,p_plug_name=>'Commercial Criterion 1 Report'
,p_parent_plug_id=>wwv_flow_api.id(286183274497515295)
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
'where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_21',
'  and DP_SCOPING_C_ID =  :P65_SCOPE_ID',
'  and TEMPLATE_ID = :P65_TEMPLATE_ID',
'  and DP_ITEM_ID = :P65_DP_ITEM_ID',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID,P65_TEMPLATE_COMPOENET_ID_21,P65_TEMPLATE_ID,P65_DP_ITEM_ID'
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
 p_id=>wwv_flow_api.id(289260518333822602)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Commercial Criterion Available'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>433462687307878566
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3854265308160421)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3854722403160421)
,p_db_column_name=>'DP_SCOPING_C_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping C Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3855081799160422)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3855498881160422)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3855928000160422)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3856259795160422)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Criterion Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3856697198160422)
,p_db_column_name=>'NOTES'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
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
 p_id=>wwv_flow_api.id(3857090215160423)
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
 p_id=>wwv_flow_api.id(3857476088160423)
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
 p_id=>wwv_flow_api.id(3857881236160423)
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
 p_id=>wwv_flow_api.id(3858257899160423)
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
 p_id=>wwv_flow_api.id(289375609955432184)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1480608'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:NOTES:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(286183318102515296)
,p_plug_name=>'Commercial Criterion 2'
,p_parent_plug_id=>wwv_flow_api.id(286043093326668960)
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
 p_id=>wwv_flow_api.id(289262309931822620)
,p_plug_name=>'Commercial Criterion 2 Report'
,p_parent_plug_id=>wwv_flow_api.id(286183318102515296)
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
'where COMPONENT_ID = :P65_TEMPLATE_COMPOENET_ID_22',
'  and DP_SCOPING_C_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID,P65_TEMPLATE_COMPOENET_ID_21,P28_TEMPLATE_ID,P28_DP_ITEM_ID'
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
 p_id=>wwv_flow_api.id(289262445481822621)
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
,p_internal_uid=>433464614455878585
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3859711912160424)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3860108837160424)
,p_db_column_name=>'DP_SCOPING_C_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping C Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3860462192160425)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3860905553160425)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3861330169160425)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3861704466160425)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Criterion Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3862086966160425)
,p_db_column_name=>'NOTES'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3862437541160426)
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
 p_id=>wwv_flow_api.id(3862860946160426)
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
 p_id=>wwv_flow_api.id(3863316344160426)
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
 p_id=>wwv_flow_api.id(3863668970160426)
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
 p_id=>wwv_flow_api.id(289376227099431951)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1480662'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_C_ID:COMPONENT_ID:TEMPLATE_ID:DP_ITEM_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3052066380104385)
,p_plug_name=>'APPENDIX D - PRICING SCHEDULE (BOQ)'
,p_icon_css_classes=>'fa-id-card-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(560973955476566263)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(3052066380104385)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>280
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       SCOPING_ID,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       SCOPING_APPENDIX,',
'       SCOPING_COMPONENT,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       COMMENT_ID,',
'      sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from DP_SCOPING_DOCUMENTS',
'  where SCOPING_ID = :P65_SCOPE_ID',
'  and SCOPING_APPENDIX = ''D''',
'    order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(560974097635566264)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No attachments available.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>705176266609622228
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3866550417163924)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3866955787163924)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3867335113163924)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::P56_ID,P56_PAGE_FROM,P56_SCOPING_APPENDIX:#ID#,31,D'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3867828893163924)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3868179685163925)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3868544867163925)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3868987614163925)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3869430860163925)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3869774105163925)
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
 p_id=>wwv_flow_api.id(3870211511163926)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3870575127163926)
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
 p_id=>wwv_flow_api.id(3870958641163926)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3871352778163926)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3871811289163926)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3872203814163927)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:DP_SCOPING_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3865342536163923)
,p_db_column_name=>'SCOPING_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Scoping Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3865822672163924)
,p_db_column_name=>'SCOPING_APPENDIX'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Scoping Appendix'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3866228533163924)
,p_db_column_name=>'SCOPING_COMPONENT'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Scoping Component'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(560999610339281431)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1480747'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3052222882104386)
,p_plug_name=>'Cashflow'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(286071155030676160)
,p_plug_name=>'Cashflow Details'
,p_parent_plug_id=>wwv_flow_api.id(3052222882104386)
,p_region_template_options=>'#DEFAULT#:t-Form--large'
,p_plug_template=>wwv_flow_api.id(127776395121449810)
,p_plug_display_sequence=>280
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(150233018694867693)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(286071155030676160)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(150233826550867701)
,p_plug_name=>'&CURRENT_YEAR. Cashflow Details'
,p_parent_plug_id=>wwv_flow_api.id(286071155030676160)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CASHFLOW_LINES'
,p_query_where=>'line_id = :P65_LINE_ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_LINE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'&CURRENT_YEAR. Cashflow Details'
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
 p_id=>wwv_flow_api.id(3012724460758549)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>147214893434814513
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3012762531758550)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3012848785758551)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Budget Allocation Plan Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3012960075758552)
,p_db_column_name=>'ACCOUNTING_YEAR'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Accounting Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3013096541758553)
,p_db_column_name=>'MULTI_YEAR_YN'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Multi Year Yn'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3013177764758554)
,p_db_column_name=>'DISTRIBUTION_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Distribution Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3013275693758555)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3013384309758556)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3013468217758557)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3013581424758558)
,p_db_column_name=>'PROJECT_NAME_NEW'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Project Name New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3013698897758559)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Task Number New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3013829349758560)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Expenditure Type New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3013906805758561)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3013986890758562)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3014129457758563)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3014188270758564)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3014259905758565)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3014389739758566)
,p_db_column_name=>'FUTURE1'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3014494305758567)
,p_db_column_name=>'FUTURE2'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3014627448758568)
,p_db_column_name=>'ENTITY_CODE_NEW'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Entity Code New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3014724884758569)
,p_db_column_name=>'COST_CENTER_NEW'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Cost Center New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3014747619758570)
,p_db_column_name=>'BUDGET_GROUB_CODE_NEW'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Budget Groub Code New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3014846560758571)
,p_db_column_name=>'GL_ACCOUNT_NEW'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Gl Account New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3015004897758572)
,p_db_column_name=>'ACTIVITY_NEW'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Activity New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3015038614758573)
,p_db_column_name=>'FUTURE1_NEW'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Future1 New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3015198815758574)
,p_db_column_name=>'FUTURE2_NEW'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Future2 New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3015247293758575)
,p_db_column_name=>'ALLOCATED_BUDGET'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Allocated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3015405382758576)
,p_db_column_name=>'BUDGET'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3015461068758577)
,p_db_column_name=>'ENCUMBERANCE'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Encumberance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3015621149758578)
,p_db_column_name=>'ACTUAL'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3015679238758579)
,p_db_column_name=>'JAN'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Jan-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3015811869758580)
,p_db_column_name=>'FEB'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Feb-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3015907490758581)
,p_db_column_name=>'MAR'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Mar-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3016019123758582)
,p_db_column_name=>'APR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Apr-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3016060390758583)
,p_db_column_name=>'MAY'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'May-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3016147857758584)
,p_db_column_name=>'JUN'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Jun-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3016283618758585)
,p_db_column_name=>'JUL'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Jul-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3016386643758586)
,p_db_column_name=>'AUG'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Aug-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3916590198208437)
,p_db_column_name=>'SEP'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Sep-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3916727600208438)
,p_db_column_name=>'OCT'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Oct-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3916794435208439)
,p_db_column_name=>'NOV'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Nov-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3916915390208440)
,p_db_column_name=>'DEC'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Dec-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3916977145208441)
,p_db_column_name=>'LINE_TYPE'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Line Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3917058194208442)
,p_db_column_name=>'TOTAL_CF'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Total Cf'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3917185939208443)
,p_db_column_name=>'NOTE'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3917234211208444)
,p_db_column_name=>'STATUS'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3917370167208445)
,p_db_column_name=>'FINAL_STATUS_ON'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Final Status On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3917454641208446)
,p_db_column_name=>'SOURCE'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3917558305208447)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3917688789208448)
,p_db_column_name=>'REQUEST_LINE_ID'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Request Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
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
 p_id=>wwv_flow_api.id(3917821556208449)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Initiative Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3917832205208450)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Initiative New Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3917949018208451)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3918033684208452)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3918216107208453)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3918246846208454)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3918368928208455)
,p_db_column_name=>'TOTAL_CF_FORMAT'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Total'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3963224255210046)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1481654'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:TOTAL_CF_FORMAT:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3558524079947856)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(150650665315762265)
,p_plug_name=>'Approval History'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P65_REVIEW_STATUS != ''Draft'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(150686890263108070)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(150650665315762265)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
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
'    h.approval_type,',
'    case h.status',
'        When ''Rejected'' Then ''u-danger-text''',
'        when ''Approved'' Then ''u-success''',
'        When ''Accepted'' Then ''u-success''',
'    End status_class,',
'       ',
'    e.full_name_en || ''('' || e.user_name || '')'' as full_name_en,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo',
'FROM',
'    DP_SCOPING_APPROVAL_HISTORY h, dct_employees_list2  e',
'where h.person_id = e.person_id (+)',
'and h.request_id = :P65_SCOPE_ID',
'and h.status != ''Beaten''',
'order by h.STEP_NO ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P65_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(150686992400108071)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>294889161374164035
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3525070653947837)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3525524853947837)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3525841087947837)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3526260736947837)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3526650437947837)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(129038068099971033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527128761947838)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527497380947838)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527864424947838)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528292565947838)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528675700947838)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529113156947839)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529448242947839)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529923522947839)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3530328879947839)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3530690161947840)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(150977925648437529)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1477332'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(102928928605007447)
,p_report_id=>wwv_flow_api.id(150977925648437529)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(150689246581108093)
,p_plug_name=>'Collabouration'
,p_icon_css_classes=>'fa-envelope-edit'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(150689831874108099)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(150689246581108093)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(424270968574686466)
,p_name=>'Comments Report'
,p_parent_plug_id=>wwv_flow_api.id(150689831874108099)
,p_template=>wwv_flow_api.id(127776395121449810)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Form--slimPadding:t-Form--large'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  ',
'        CASE',
'            WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'     End   user_icon,',
'  updated_date  comment_date,',
'  full_name_en user_name,',
'  comment_text                    comment_text,',
'  null comment_modifiers,',
'   ''u-color-''||ora_hash(user_name,45) icon_modifier,',
'  ACTION     actions,',
'  ''''     attribute_1,',
'  ''''     attribute_2,',
'  ''''    attribute_3,',
'  sys.dbms_lob.getlength(file_blob)     attribute_4,',
'  comment_id,',
'  filename',
'  --',
',(Select e.full_name_en',
'                    from employees_v e',
'                    where e.person_id = comment_to_person_id)',
'         Comment_to',
'--',
'from   ',
'(SELECT',
'    c.comment_id,',
'    c.ITEM_ID,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action        action,',
'    e.full_name_en,',
'    e.user_name,',
'    e.photo_blob,',
'    c.filename,',
'    c.file_blob,',
'    c.comment_to_person_id',
'FROM',
'    dp_items_comments c , dct_employees_list2 e',
'where c.updated_by = e.person_id',
')',
'where ITEM_ID = :P65_DP_ITEM_ID',
'order by CREATION_DATE desc;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P65_DP_ITEM_ID'
,p_query_row_template=>wwv_flow_api.id(127832693224449762)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Communications yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3553583102947853)
,p_query_column_id=>1
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>1
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#USER_ICON#" alt="Image Not Found" height="40" width="40">'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3553936400947853)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_column_html_expression=>'<br>#COMMENT_DATE#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3554350796947853)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span style="color:red">From: #USER_NAME# </span>'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3553135639947853)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_COMMENT_ID:#COMMENT_ID#'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3554747744947854)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3555192246947854)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3555585004947854)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3555991253947854)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3556417470947854)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3556802766947854)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3557154755947855)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3557550282947855)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3558020619947855)
,p_query_column_id=>13
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>13
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3552768527947853)
,p_query_column_id=>14
,p_column_alias=>'COMMENT_TO'
,p_column_display_sequence=>14
,p_column_heading=>'Comment To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(285892033524282919)
,p_plug_name=>'Audit'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3457917525947777)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(285893775180282937)
,p_button_name=>'PROJECT_OVERVIEW_HELP_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Introduction Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Requirement Overview,&P65_TEMPLATE_ID.,10'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'Y'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3454511932947774)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(149876730128191766)
,p_button_name=>'DCT_REPRESENTATIVES_AND_SUPPORT_HELP_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'DCT Representatives and Support'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:DCT Representatives and Support,&P65_TEMPLATE_ID.,9'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'Y'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3442564737947766)
,p_button_sequence=>230
,p_button_plug_id=>wwv_flow_api.id(285893713356282936)
,p_button_name=>'LOCATION_OF_WORK_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Location of Work Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Location of Work Guidance,&P65_TEMPLATE_ID.,6'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'N'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3442230394947766)
,p_button_sequence=>270
,p_button_plug_id=>wwv_flow_api.id(285893713356282936)
,p_button_name=>'LANGUAGE_OF_WORK_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Language of Work Guidance,&P65_TEMPLATE_ID.,7'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'N'
,p_grid_column=>6
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3442934051947766)
,p_button_sequence=>310
,p_button_plug_id=>wwv_flow_api.id(285893713356282936)
,p_button_name=>'PROVISION_OF_SERVICES_HELP_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Provision of Services Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Provision of Service Guidance,&P65_TEMPLATE_ID.,8'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'Y'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3440644839947765)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(283840436769007761)
,p_button_name=>'PROJECT_OVERVIEW_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Project Overview Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Project Overview,1'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3456399288947776)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(283840710683007764)
,p_button_name=>'REQUIREMENTS_OVERVIEW_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Requirements Overview,2'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3460608780947779)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285768917634302660)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:52:&SESSION.::&DEBUG.:52:P52_DP_SCOPING_A_ID:&P65_SCOPE_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3471020505947791)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285748530098341738)
,p_button_name=>'SUPPLIER_RESPONSIBILITIES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Supplier Responsibilities,8'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3477163462947795)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285748868020341742)
,p_button_name=>'PROPOSAL_SUBMISSION'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Proposal Submission Requirements,9'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3483752227947799)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285749345322341746)
,p_button_name=>'Security_Requirement_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Security Requirements,10'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3489588448947802)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285749698227341750)
,p_button_name=>'DATA_CAPTURE_REQUIREMENTS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Data Capture Requirements,11'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3495331191947809)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(283841051834007768)
,p_button_name=>'TIMELINES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Timelines,3'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3500013802947812)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285746895365341722)
,p_button_name=>'SUBMISSION_INFORMATION_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Submission Information,4'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3505041414947814)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285747326098341726)
,p_button_name=>'SCOPE_OF_SERVICES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Scope of Services,5'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3507579836947816)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285747682512341730)
,p_button_name=>'REQUIRED_DELIVERABLES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Required Deliverables,6'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3516982067947821)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285748095201341734)
,p_button_name=>'PERFORMANCE_MEASUREMENTS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Performance Measurements,7'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3532203184947841)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285750143276341754)
,p_button_name=>'INTELLECTUAL_PROPERTY'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Intellectual Property/Copyrights of Work,12'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3534090761947842)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285750451117341758)
,p_button_name=>'REPORTING_COM_REQ_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Reporting & Communication Requirements,13'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3535948228947843)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285750878607341762)
,p_button_name=>'ADDED_VALUE_OFFERINGS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Added Value Offerings,14'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3537847193947844)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(285751274636341766)
,p_button_name=>'ATT_SUPP_DOCS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Attachments and Supporting Documents,15'
,p_icon_css_classes=>'fa-question-circle-o'
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
 p_id=>wwv_flow_api.id(3539406807947845)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(414523003294983840)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::P56_SCOPING_ID,P56_PAGE_FROM,P56_SCOPING_APPENDIX:&P65_SCOPE_ID.,28,A'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3552107156947852)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(150689831874108099)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Collaborate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_ITEM_ID:&P65_DP_ITEM_ID.'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3465958801947788)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(285795719008072125)
,p_button_name=>'Add_O'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.:55:P55_DP_SCOPING_A_ID:&P65_SCOPE_ID.'
,p_button_condition=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3471417509947792)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(285748530098341738)
,p_button_name=>'Add_Resp'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:35:P35_DP_SCOPING_A_ID:&P65_SCOPE_ID.'
,p_button_condition=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3477584586947795)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(285748868020341742)
,p_button_name=>'Add_Requirement'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add Requirement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:36:P36_DP_SCOPING_A_ID:&P65_SCOPE_ID.'
,p_button_condition=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3484175300947799)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(285749345322341746)
,p_button_name=>'New_Security_Requirement'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'New Security Requirement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.:37:P37_DP_SCOPING_A_ID:&P65_SCOPE_ID.'
,p_button_condition=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3490029631947802)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(285749698227341750)
,p_button_name=>'New_Data_Capture'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'New Data Capture'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.:38:P38_DP_SCOPING_A_ID:&P65_SCOPE_ID.'
,p_button_condition=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3508019539947816)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(285747682512341730)
,p_button_name=>'New_deliverable'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'New Deliverable'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.:33:P33_DP_SCOPING_A_ID:&P65_SCOPE_ID.'
,p_button_condition=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3517409629947821)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(285748095201341734)
,p_button_name=>'New_KPI'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'New KPI'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.::P34_DP_SCOPING_A_ID:&P65_SCOPE_ID.'
,p_button_condition=>':P65_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3974063586252677)
,p_button_sequence=>320
,p_button_plug_id=>wwv_flow_api.id(3558524079947856)
,p_button_name=>'Approve'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'&P65_APPROVAL_LABEL.'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:66:&SESSION.::&DEBUG.:66:P66_ACTION,P66_HISTORY_ID,P66_REQUEST_ID:Approve,&P65_HISTORY_ID.,&P65_SCOPE_ID.'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3974339287254290)
,p_button_sequence=>330
,p_button_plug_id=>wwv_flow_api.id(3558524079947856)
,p_button_name=>'Reject'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'&P65_REJECT_LABEL.'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:66:&SESSION.::&DEBUG.:66:P66_ACTION,P66_HISTORY_ID,P66_REQUEST_ID:Reject,&P65_HISTORY_ID.,&P65_SCOPE_ID.'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3974716959255556)
,p_button_sequence=>340
,p_button_plug_id=>wwv_flow_api.id(3558524079947856)
,p_button_name=>'Delegate'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:66:&SESSION.::&DEBUG.:66:P66_ACTION,P66_HISTORY_ID,P66_REQUEST_ID:Delegate,&P65_HISTORY_ID.,&P65_SCOPE_ID.'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3974986619256571)
,p_button_sequence=>350
,p_button_plug_id=>wwv_flow_api.id(3558524079947856)
,p_button_name=>'Return'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:66:&SESSION.::&DEBUG.:66:P66_ACTION,P66_HISTORY_ID,P66_REQUEST_ID:Return,&P66_HISTORY_ID.,&P65_SCOPE_ID.'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3975237374257540)
,p_button_sequence=>360
,p_button_plug_id=>wwv_flow_api.id(3558524079947856)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(3599751448947876)
,p_branch_name=>'Go To Page 29'
,p_branch_action=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.::P29_SCOPE_ID,P29_TEMPLATE_ID,P29_ITEM_ID:&P65_SCOPE_ID.,&P65_TEMPLATE_ID.,&P65_DP_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3438043928947760)
,p_name=>'P65_SCOPE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(288095837953098754)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3438440255947762)
,p_name=>'P65_TEMPLATE_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(288095837953098754)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3438904879947762)
,p_name=>'P65_SCOPE_CODE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(288095837953098754)
,p_prompt=>'Scope Document Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3439326509947762)
,p_name=>'P65_DP_ITEM_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(288095837953098754)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3441118599947765)
,p_name=>'P65_PROJECT_OVERVIEW_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(283840436769007761)
,p_prompt=>'PROJECT_OVERVIEW_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3441516372947765)
,p_name=>'P65_PROJECT_OVERVIEW_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(283840436769007761)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3443425171947766)
,p_name=>'P65_PROJECT_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_prompt=>'&P65_PROJECT_NAME_LABEL.'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN( ''A'' , :P65_TEMPLATE_ID ,  1 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3443792332947767)
,p_name=>'P65_PROJECT_NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_prompt=>'Project Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P65_PROJECT_NUMBER'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3444147325947767)
,p_name=>'P65_PROJECT_CODE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_prompt=>'Project Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P65_PROJECT_CODE'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3444629041947767)
,p_name=>'P65_PROJECT_NAME_LABEL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P65_TEMPLATE_ID ,  1)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3445002616947768)
,p_name=>'P65_MAIN_CATEGORY_ID'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_prompt=>'Main Category'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM MAIN CATEGORIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 231 ;'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3445400009947769)
,p_name=>'P65_DATE_REQUIRED'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_prompt=>'&P65_DATE_REQUIRED_LABEL.'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  2) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'&P28_DATE_REQUIRED_HELP.'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3445809125947769)
,p_name=>'P65_DATE_REQUIRED_LABEL'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P65_TEMPLATE_ID ,  2 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3446222552947769)
,p_name=>'P65_DATE_REQUIRED_HELP'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P65_TEMPLATE_ID ,  2 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3446587517947769)
,p_name=>'P65_SUB_CATEGORY_ID'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_prompt=>'&P65_SUB_CATEGORY_ID_LABEL.'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM SUB CATEGORIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 233 ;'))
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  4 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'&P28_SUB_CATEGORY_ID_HELP.'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3446981860947769)
,p_name=>'P65_RFP_REF_NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_prompt=>'&P65_RFP_REF_NUMBER_LABEL.'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  5 ) = ''Y'' and :P65_RFP_REF_NUMBER is not null'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>'IS_PBP_EMP'
,p_read_only_when2=>'Y'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'&P28_RFP_REF_NUMBER_HELP.'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3447407182947769)
,p_name=>'P65_CATEGORY_ID'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_prompt=>'&P65_CATEGORY_ID_LABEL.'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM CATEGORY  LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 232 ;'))
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  3) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'&P28_CATEGORY_ID_HELP.'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3447813230947770)
,p_name=>'P65_CATEGORY_ID_LABEL'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P65_TEMPLATE_ID , 3)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3448175557947770)
,p_name=>'P65_CATEGORY_ID_HELP'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P65_TEMPLATE_ID , 3)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3448615470947770)
,p_name=>'P65_SUB_CATEGORY_ID_LABEL'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P65_TEMPLATE_ID , 4 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3449017977947770)
,p_name=>'P65_SUB_CATEGORY_ID_HELP'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P65_TEMPLATE_ID , 4 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3449376214947770)
,p_name=>'P65_TEMPLATE'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_prompt=>'Template'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'SCOPING TEMPLATES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_SCOPE_TEMPLATES.TEMPLATE_NAME as TEMPLATE_NAME ,',
'    DP_SCOPE_TEMPLATES.TEMPLATE_ID as TEMPLATE_ID',
' from DP_SCOPE_TEMPLATES DP_SCOPE_TEMPLATES',
' where status = ''A''',
' and sysdate between nvl(start_date , sysdate -10) and nvl(end_date , sysdate +10)'))
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3449764908947771)
,p_name=>'P65_RFP_REF_NUMBER_LABEL'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P65_TEMPLATE_ID ,  5 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3450155795947771)
,p_name=>'P65_RFP_REF_NUMBER_HELP'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P65_TEMPLATE_ID ,  5 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3450619874947771)
,p_name=>'P65_LOCATION_OF_WORK'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_prompt=>'&P65_LOCATION_OF_WORK_LABEL.'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>120
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  6 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_item_comment=>'&P65_LOCATION_OF_WORK_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3450972702947772)
,p_name=>'P65_LOCATION_OF_WORK_LABEL'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P65_TEMPLATE_ID ,  6 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3451371468947772)
,p_name=>'P65_LOCATION_OF_WORK_HELP'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P65_TEMPLATE_ID ,  6 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3451815751947772)
,p_name=>'P65_LANGUAGE_OF_WORK'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_prompt=>'&P65_LANGUAGE_OF_WORK_LABEL.'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LANGUAGE LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LANGUAGE d, LANGUAGE r',
'from languages',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  7) = ''Y'' and 1=2'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
,p_item_comment=>'&P65_LANGUAGE_OF_WORK_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3452181292947772)
,p_name=>'P65_LANGUAGE_OF_WORK_LABEL'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P65_TEMPLATE_ID , 7 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3452626406947772)
,p_name=>'P65_LANGUAGE_OF_WORK_HELP'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P65_TEMPLATE_ID , 7 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3453024460947772)
,p_name=>'P65_PROVISION_OF_SERVICES'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P65_TEMPLATE_ID ,  8 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'&P65_PROVISION_OF_SERVICES_LABEL.'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN( ''A'' , :P65_TEMPLATE_ID ,  8 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_item_comment=>'&P65_PROVISION_OF_SERVICES_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3453336870947773)
,p_name=>'P65_PROVISION_OF_SERVICES_LABEL'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P65_TEMPLATE_ID ,  8 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3453739258947773)
,p_name=>'P65_PROVISION_OF_SERVICES_HELP'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(285893713356282936)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P65_TEMPLATE_ID ,  8 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3454832035947774)
,p_name=>'P65_DCT_REPRESENTATIVES_AND_SUPPORT'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(149876730128191766)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P65_TEMPLATE_ID ,  9 ) '
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'&P65_DCT_REPRESENTATIVES_AND_SUPPORT_LABEL.'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  9 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_item_comment=>'&P65_DCT_REPRESENTATIVES_AND_SUPPORT_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3455295164947775)
,p_name=>'P65_DCT_REPRESENTATIVES_AND_SUPPORT_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(149876730128191766)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P65_TEMPLATE_ID , 9 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3455660583947775)
,p_name=>'P65_DCT_REPRESENTATIVES_AND_SUPPORT_HELP'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(149876730128191766)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P65_TEMPLATE_ID , 9 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3456741146947776)
,p_name=>'P65_REQUIREMENTS_OVERVIEW_LAB'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(283840710683007764)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3457179752947776)
,p_name=>'P65_REQUIREMENTS_OVERVIEW_HELP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(283840710683007764)
,p_prompt=>'REQUIREMENTS_OVERVIEW_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3458304517947777)
,p_name=>'P65_INTRODUCTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285893775180282937)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P65_TEMPLATE_ID ,  10 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'&P65_INTRODUCTION_LABEL.'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  10 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_item_comment=>'&P65_INTRODUCTION_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3458676565947777)
,p_name=>'P65_INTRODUCTION_HELP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(285893775180282937)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P65_TEMPLATE_ID , 10  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'U'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3459069151947777)
,p_name=>'P65_INTRODUCTION_LABEL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(285893775180282937)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P65_TEMPLATE_ID , 10  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'U'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3459458328947777)
,p_name=>'P65_ABOUT_DCT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(285893775180282937)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P65_TEMPLATE_ID ,  11 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'About DCT'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>10
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  11 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3459923666947777)
,p_name=>'P65_BACKGROUND_AND_SERVICES_REQUIRED'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(285893775180282937)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P65_TEMPLATE_ID ,  12 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Background and Services Required'
,p_display_as=>'NATIVE_TEXTAREA'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  12 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3471771422947792)
,p_name=>'P65_SUPPLIER_RES_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285748530098341738)
,p_prompt=>'SUPPLIER_RESPONSIBILITIES_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3472215526947792)
,p_name=>'P65_SUPPLIER_RESPONS_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285748530098341738)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3478029017947795)
,p_name=>'P65_PROPO_SUBMISSION_REQ_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285748868020341742)
,p_prompt=>'PROPOSAL_SUBMISSION_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
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
 p_id=>wwv_flow_api.id(3478392196947795)
,p_name=>'P65_PROPOSAL_SUBM_REQ_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285748868020341742)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3484613808947799)
,p_name=>'P65_SECURITY_REQUIREMENTS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285749345322341746)
,p_prompt=>'SECURITY_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3485011860947799)
,p_name=>'P65_SECURITY_REQUIREMENT_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285749345322341746)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3490343123947802)
,p_name=>'P65_DATA_CAPTURE_REQ_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285749698227341750)
,p_prompt=>'DATA_CAPTURE_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3490737394947802)
,p_name=>'P65_DATA_CAPTURE_REQ_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285749698227341750)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3495780326947810)
,p_name=>'P65_TIMELINES_LABEL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(283841051834007768)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3496209301947810)
,p_name=>'P65_TIMELINES_HELP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(283841051834007768)
,p_prompt=>'TIMELINES_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3496924861947810)
,p_name=>'P65_EXPECTED_START_DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285893904932282938)
,p_prompt=>'Expected Contract Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  13 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3497242421947810)
,p_name=>'P65_EXPECTED_END_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(285893904932282938)
,p_prompt=>'Expected Contract End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  14 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3497650239947811)
,p_name=>'P65_TENDER_START_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(285893904932282938)
,p_prompt=>'Expected Tender start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  15 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3498063593947811)
,p_name=>'P65_TENDER_END_DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(285893904932282938)
,p_prompt=>'Expected Tender End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  16 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3498458415947811)
,p_name=>'P65_EXPECTED_CONTRACT_START_DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(285893904932282938)
,p_prompt=>'Expected Contract Start Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3498853071947811)
,p_name=>'P65_EXPECTED_CONTRACT_END_DATE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(285893904932282938)
,p_prompt=>'Expected Contract End Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3499326632947811)
,p_name=>'P65_DURATION_COMMENTS'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(285893904932282938)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P65_TEMPLATE_ID ,  17 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Duration Comments'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  17 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3500365062947812)
,p_name=>'P65_SUBMISSION_INFO_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285746895365341722)
,p_prompt=>'SUBMISSION_INFORMATION_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3500756484947812)
,p_name=>'P65_TECHNICAL_SUBMISSION_ID_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285746895365341722)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P65_TEMPLATE_ID , 18  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3501222862947812)
,p_name=>'P65_TECHNICAL_SUBMISSION_ID_HELP'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(285746895365341722)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P65_TEMPLATE_ID , 18  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3501575763947812)
,p_name=>'P65_TECHNICAL_SUBMISSION_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(285746895365341722)
,p_prompt=>'&P65_TECHNICAL_SUBMISSION_ID_LABEL.'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TECHNICAL SUBMISSION LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 51 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  18 ) = ''Y'' and 1 =2'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
,p_item_comment=>'&P65_TECHNICAL_SUBMISSION_ID_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3501953871947813)
,p_name=>'P65_BAFO_NEGOTIATION_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(285746895365341722)
,p_prompt=>'&P65_BAFO_NEGOTIATION_ID_LABEL.'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(128345817677489797)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN( ''A'' , :P65_TEMPLATE_ID ,  19) = ''Y'' and 1 =2'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_inline_help_text=>'&P28_BAFO_NEGOTIATION_ID_HELP.'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3502387898947813)
,p_name=>'P65_SELECTION_CRITERIA'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(285746895365341722)
,p_prompt=>'Selection Criteria'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'MPR PROCUREMENT METHODS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select MPR_PROCUREMENT_METHODS.PROCUREMENT_METHOD_NAME as PROCUREMENT_METHOD_NAME,',
'    MPR_PROCUREMENT_METHODS.ID as ID ',
' from MPR_PROCUREMENT_METHODS MPR_PROCUREMENT_METHODS'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3502786825947813)
,p_name=>'P65_TECH_PCT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(285746895365341722)
,p_prompt=>'Technical'
,p_post_element_text=>'%'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_begin_on_new_line=>'N'
,p_grid_column=>8
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3503182503947813)
,p_name=>'P65_COMM_PCT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(285746895365341722)
,p_prompt=>'Commercial'
,p_post_element_text=>'%'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_begin_on_new_line=>'N'
,p_grid_column=>10
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3503548730947813)
,p_name=>'P65_BAFO_NEGOTIATION_ID_LABEL'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(285746895365341722)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P65_TEMPLATE_ID , 19 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3504010966947814)
,p_name=>'P65_BAFO_NEGOTIATION_ID_HELP'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(285746895365341722)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P65_TEMPLATE_ID , 19 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3504426990947814)
,p_name=>'P65_SUBMISSION_INFO_LABEL'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(285746895365341722)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3505827466947815)
,p_name=>'P65_SCOPE_OF_SERVICES_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(150688770352108088)
,p_use_cache_before_default=>'NO'
,p_prompt=>'SCOPE_OF_SERVICES_HELP'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE (  ''A'' , :P65_TEMPLATE_ID ,  20 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  20 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3506446068947815)
,p_name=>'P65_SCOPE_OF_SERVICES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(150688967162108090)
,p_prompt=>'Scope of Services'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  20 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3506914625947815)
,p_name=>'P65_SCOPE_OF_SERVICES_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(150688967162108090)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3508407367947816)
,p_name=>'P65_REQUIRED_DELIVERABLES_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285747682512341730)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3508733520947816)
,p_name=>'P65_REQUIRED_DELIVERABLE_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285747682512341730)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3517754001947821)
,p_name=>'P65_PERFOR_MEASUR_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285748095201341734)
,p_prompt=>'PERFORMANCE_MEASUREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3518174582947821)
,p_name=>'P65_PERFORM_MEASUR_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285748095201341734)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3532590909947841)
,p_name=>'P65_INTEL_PROP_COPYRIGHTS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285750143276341754)
,p_prompt=>'INTELLECTUAL_PROPERTY_COPYRIGHTS_OF_WORK_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3532986431947841)
,p_name=>'P65_INTELLECTUAL_PROPERTY_COPYRIGHTS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285750143276341754)
,p_prompt=>'Intellectual Property Copyrights'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  21 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3533359846947841)
,p_name=>'P65_INTELL_PRO_COPYRIGHTSLABEL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(285750143276341754)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3534528155947842)
,p_name=>'P65_REPORT_COMM_REQ_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285750451117341758)
,p_prompt=>'REPORTING_COMMUNICATION_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3534892160947842)
,p_name=>'P65_REPORTING_COMMUNICATION_REQ'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285750451117341758)
,p_prompt=>'Reporting Communication Requirements'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  22 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3535231828947843)
,p_name=>'P65_REPORT_COMM_REQ_LABEL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(285750451117341758)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3536336387947843)
,p_name=>'P65_ADDED_VALUE_OFFERINGS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285750878607341762)
,p_prompt=>'ADDED_VALUE_OFFERINGS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3536750357947843)
,p_name=>'P65_ADDED_VALUE_OFFERINGS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285750878607341762)
,p_prompt=>'Added Value Offerings'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P65_TEMPLATE_ID ,  23 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3537160160947844)
,p_name=>'P65_ADDED_VALUE_OFFERINGS_LAB'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(285750878607341762)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3538282973947844)
,p_name=>'P65_ATT_DOCUMENTS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285751274636341766)
,p_prompt=>'ATTACHMENTS_SUPPORTING_DOCUMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3538655917947844)
,p_name=>'P65_ATTACH_DOC_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(285751274636341766)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3547959810947850)
,p_name=>'P65_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(285892033524282919)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3548372636947850)
,p_name=>'P65_CREATION_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(285892033524282919)
,p_prompt=>'Creation Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3548766121947850)
,p_name=>'P65_UPDATED_BY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(285892033524282919)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3549203890947850)
,p_name=>'P65_UPDATED_DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(285892033524282919)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3549889633947851)
,p_name=>'P65_ITEM_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(288095837953098754)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Item Name'
,p_source=>'P65_DP_ITEM_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_ITEM_NAME , item_id',
'from dp_items;'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3550235485947851)
,p_name=>'P65_TEMPLATE_NAME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(288095837953098754)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template Name'
,p_source=>'P65_TEMPLATE_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'SCOPING TEMPLATES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_SCOPE_TEMPLATES.TEMPLATE_NAME as TEMPLATE_NAME ,',
'    DP_SCOPE_TEMPLATES.TEMPLATE_ID as TEMPLATE_ID',
' from DP_SCOPE_TEMPLATES DP_SCOPE_TEMPLATES',
' where status = ''A''',
' and sysdate between nvl(start_date , sysdate -10) and nvl(end_date , sysdate +10)'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3550688572947851)
,p_name=>'P65_REVIEW_STATUS'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(288095837953098754)
,p_prompt=>'Review Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3551032918947851)
,p_name=>'P65_APPROVAL_STATUS'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(288095837953098754)
,p_prompt=>'Approval Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3667193938973237)
,p_name=>'P65_HISTORY_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(288095837953098754)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3683259415060793)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_89'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289003125586924779)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 89',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3689492658060816)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_90'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289004769079924795)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 90',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3695634015060819)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_91'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289020728354905361)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 91',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3701878511060823)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_92'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289022399924905377)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 92',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3708092772060828)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_93'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289023988397905393)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 93',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3714253217060840)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_94'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289042836821798659)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 94',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3720501281060846)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_96'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289044421350798675)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 96',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3726728069060850)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_97'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289046027893798691)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 97',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3732843685060853)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_98'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289067380206765157)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 98',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3738993015060859)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_99'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289067627132765160)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 99',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3745189399060864)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_100'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289070575178765189)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 100',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3751376580060868)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_101'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289072145268765205)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 101',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3757602497060871)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_16'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(286011509169415658)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 16',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3763748378060875)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_17'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(286011623824415659)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 17',
'AND template_id = :P65_TEMPLATE_ID;'))
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
 p_id=>wwv_flow_api.id(3770023125060878)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_18'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(286011879873415661)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 18',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3776188921060882)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_19'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(286012031828415663)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 19',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3782417962060887)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_20'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(286012281586415665)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 20',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3788596354060892)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_81'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(288943114995037001)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 81',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3794785600060896)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_82'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(288959642542991867)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 82',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3800985867060899)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_83'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(288961283428991883)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 83',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3807215642060903)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_84'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(288962891777991899)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 84',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3813426720060907)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_85'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(288979722366952165)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 85',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3819544834060912)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_86'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(288981345016952181)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 86',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3825796925060915)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_87'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(288982953847952197)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 87',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3832024506060919)
,p_name=>'P65_TEMPLATE_COMPOENET_ID_88'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(289001533403924763)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 88',
'AND template_id = :P65_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3873642165167658)
,p_name=>'P65_LINE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3874061351167658)
,p_name=>'P65_BUDGET_ALLOCATION_PLAN_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3874524765167658)
,p_name=>'P65_ACCOUNTING_YEAR'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3874842018167659)
,p_name=>'P65_MULTI_YEAR_YN'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_prompt=>'Multi Year ?'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3875269599167659)
,p_name=>'P65_DISTRIBUTION_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3875727000167659)
,p_name=>'P65_PROJECT_NUMBER_1'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_prompt=>'Project Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3876035750167659)
,p_name=>'P65_ESTIMATED_BUDGET'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Estimated Budget'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(estimated_budget,''99,999,999,999,999.99'')) || '' AED'' bud',
'from dp_items',
'where item_id = :P65_DP_ITEM_ID	'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3876453165167659)
,p_name=>'P65_TASK_NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_prompt=>'Task'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TASK_NUMBER d, TASK_NUMBER r ',
'from task',
'where PROJECT_NUMBER = :P65_PROJECT_NUMBER'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P65_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3876868816167659)
,p_name=>'P65_STATUS'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3877290911167660)
,p_name=>'P65_EXPENDITURE_TYPE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_prompt=>'Expenditure Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXPENDITURE_TYPE d, EXPENDITURE_TYPE r',
'from expenditure',
'where PROJECT_NUMBER =  :P65_PROJECT_NUMBER',
'and TASK_NUMBER = :P65_TASK_NUMBER;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P65_PROJECT_NUMBER,P65_TASK_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3877680922167660)
,p_name=>'P65_NEW_PROJECT_NAME'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_prompt=>'New Project Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when=>'P65_NEW_PROJECT_NAME'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3878089346167662)
,p_name=>'P65_NEW_TASK_NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_prompt=>'New Task'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when=>'P65_NEW_TASK_NUMBER'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3878473970167662)
,p_name=>'P65_NEW_EXPENDITURE_TYPE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_prompt=>'New Expenditure Type'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when=>'P65_NEW_EXPENDITURE_TYPE'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3878842844167663)
,p_name=>'P65_ENTITY_CODE'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3879298831167663)
,p_name=>'P65_ENTITY_CODE_NEW'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3879715312167663)
,p_name=>'P65_COST_CENTER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3880111647167663)
,p_name=>'P65_COST_CENTER_NEW'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3880499092167663)
,p_name=>'P65_BUDGET_GROUB_CODE'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3880889700167664)
,p_name=>'P65_BUDGET_GROUB_CODE_NEW'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3881330201167664)
,p_name=>'P65_GL_ACCOUNT'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3881690356167664)
,p_name=>'P65_GL_ACCOUNT_NEW'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3882098131167664)
,p_name=>'P65_ACTIVITY'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3882466120167664)
,p_name=>'P65_ACTIVITY_NEW'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3882882605167664)
,p_name=>'P65_FUTURE1'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3883262450167665)
,p_name=>'P65_FUTURE1_NEW'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3883666208167665)
,p_name=>'P65_FUTURE2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3884061273167665)
,p_name=>'P65_FUTURE2_NEW'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3884499957167665)
,p_name=>'P65_ALLOCATED_BUDGET'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3884871040167665)
,p_name=>'P65_LINE_TYPE'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3885281376167666)
,p_name=>'P65_NOTE'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_prompt=>'Note'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>70
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3885694102167666)
,p_name=>'P65_SOURCE'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3886045007167666)
,p_name=>'P65_REQUEST_ID'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3886523659167666)
,p_name=>'P65_INITIATIVE_ID'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3886927842167666)
,p_name=>'P65_INITIATIVE_NEW_NAME'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3887290343167666)
,p_name=>'P65_SUB_CATEGORY_ID_1'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3887689359167667)
,p_name=>'P65_TEMPLATE_ID_1'
,p_item_sequence=>370
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3888129988167667)
,p_name=>'P65_ITEM_ID'
,p_item_sequence=>380
,p_item_plug_id=>wwv_flow_api.id(286071155030676160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3888771457167667)
,p_name=>'P65_CREATED_BY_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(150233018694867693)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3889177556167667)
,p_name=>'P65_CREATED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(150233018694867693)
,p_prompt=>'Created ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3889615840167668)
,p_name=>'P65_UPDATED_BY_1'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(150233018694867693)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3889967610167668)
,p_name=>'P65_UPDATED_ON'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(150233018694867693)
,p_prompt=>'Updated ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3975626513277030)
,p_name=>'P65_APPROVAL_LABEL'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_api.id(3558524079947856)
,p_prompt=>'APPROVE'
,p_display_as=>'NATIVE_HIDDEN'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3975862975279851)
,p_name=>'P65_REJECT_LABEL'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_api.id(3558524079947856)
,p_prompt=>'REJECT'
,p_display_as=>'NATIVE_HIDDEN'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3918535486208457)
,p_computation_sequence=>10
,p_computation_item=>'P65_APPROVAL_LABEL'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  case action_required when ''Approve/Reject''   then ''Approve''',
'                                                when ''Recommend/Return'' then ''Recommend''',
'                                                when ''Forward/Return'' then ''Forward''',
'                                                when ''Review/Return''  then ''Review''',
'                                                else ''Approve''',
'        end approve_action',
'from dp_scoping_approval_history',
'where ID = :P65_HISTORY_ID;'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3918712006208458)
,p_computation_sequence=>20
,p_computation_item=>'P65_REJECT_LABEL'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  case action_required when ''Approve/Reject''   then ''Reject''',
'                                                when ''Recommend/Return'' then ''Return''',
'                                                when  ''Forward/Return''     then ''Returned''',
'                                                when ''Review/Return''  then ''Not Accepted''',
'                                                else ''Reject''',
'        end reject_action',
'from dp_scoping_approval_history',
'where ID = :P65_HISTORY_ID;'))
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(3559057003947859)
,p_validation_name=>'Validate Evaluation Criteria %'
,p_validation_sequence=>10
,p_validation=>':P65_TECH_PCT + :P65_COMM_PCT = 100'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Total Commercial% and Technical% must be 100. '
,p_always_execute=>'Y'
,p_associated_item=>wwv_flow_api.id(3503182503947813)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3582569127947870)
,p_name=>'Deliverable Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3508019539947816)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3583089829947870)
,p_event_id=>wwv_flow_api.id(3582569127947870)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285797320352072141)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3583471619947870)
,p_name=>'Deliverable Close DA2'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(285797320352072141)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3583945175947870)
,p_event_id=>wwv_flow_api.id(3583471619947870)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285797320352072141)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3584422628947871)
,p_name=>'Performance Measurements Closing DA2'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(285798489918072153)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3584897857947871)
,p_event_id=>wwv_flow_api.id(3584422628947871)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285798489918072153)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3585268098947871)
,p_name=>'Performance Measurements Closing DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3517409629947821)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3585805425947871)
,p_event_id=>wwv_flow_api.id(3585268098947871)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285798489918072153)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3586209790947871)
,p_name=>'DP_SCOPING_A_SUPPLIER_RESP Dialog Close DA'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3471417509947792)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3586664929947872)
,p_event_id=>wwv_flow_api.id(3586209790947871)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285799786724072166)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3587082159947872)
,p_name=>'DP_SCOPING_A_SUPPLIER_RESP Dialog Close DA2'
,p_event_sequence=>60
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(285799786724072166)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3587615678947872)
,p_event_id=>wwv_flow_api.id(3587082159947872)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285799786724072166)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3588029654947872)
,p_name=>'Expand'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3471417509947792)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3588494603947872)
,p_event_id=>wwv_flow_api.id(3588029654947872)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285748530098341738)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3588881188947872)
,p_name=>'Close DA'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3477584586947795)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3589349163947872)
,p_event_id=>wwv_flow_api.id(3588881188947872)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285846808213173428)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3589748089947873)
,p_name=>'Open Dialog'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3477584586947795)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3590245876947873)
,p_event_id=>wwv_flow_api.id(3589748089947873)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285748868020341742)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3590662886947873)
,p_name=>'Close Dialog2'
,p_event_sequence=>100
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(285846808213173428)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3591209682947873)
,p_event_id=>wwv_flow_api.id(3590662886947873)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285846808213173428)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3591614645947873)
,p_name=>'DA Close3'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3484175300947799)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3592075814947873)
,p_event_id=>wwv_flow_api.id(3591614645947873)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285848139622173441)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3592446379947873)
,p_name=>'Open3'
,p_event_sequence=>120
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3484175300947799)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3592972337947874)
,p_event_id=>wwv_flow_api.id(3592446379947873)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285749345322341746)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3593387902947874)
,p_name=>'DA Close3A'
,p_event_sequence=>130
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(285848139622173441)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3593880769947874)
,p_event_id=>wwv_flow_api.id(3593387902947874)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285848139622173441)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3594324975947874)
,p_name=>'Dialog Close4'
,p_event_sequence=>140
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3490029631947802)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3594793822947874)
,p_event_id=>wwv_flow_api.id(3594324975947874)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285849227872173452)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3595131238947874)
,p_name=>'Open4'
,p_event_sequence=>150
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3490029631947802)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3595724175947875)
,p_event_id=>wwv_flow_api.id(3595131238947874)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285749698227341750)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3596048950947875)
,p_name=>'Dialog Close4A'
,p_event_sequence=>160
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(285849227872173452)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3596602346947875)
,p_event_id=>wwv_flow_api.id(3596048950947875)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285849227872173452)
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
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3596940724947875)
,p_name=>'Add DA'
,p_event_sequence=>170
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3460608780947779)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3597497387947875)
,p_event_id=>wwv_flow_api.id(3596940724947875)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285768979435302661)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3597925444947875)
,p_name=>'Changes Refresh DA'
,p_event_sequence=>180
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(285768979435302661)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3598406534947875)
,p_event_id=>wwv_flow_api.id(3597925444947875)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285768979435302661)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3598821603947876)
,p_name=>'Add_O DA'
,p_event_sequence=>190
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3465958801947788)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3599274746947876)
,p_event_id=>wwv_flow_api.id(3598821603947876)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285795869943072127)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3560222246947861)
,p_name=>'Add_O DA2'
,p_event_sequence=>200
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(285795869943072127)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3560637877947862)
,p_event_id=>wwv_flow_api.id(3560222246947861)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(285795869943072127)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3579252702947869)
,p_name=>'Selection Criteria DA'
,p_event_sequence=>220
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P65_SELECTION_CRITERIA'
,p_condition_element=>'P65_SELECTION_CRITERIA'
,p_triggering_condition_type=>'IN_LIST'
,p_triggering_expression=>'2'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3579796369947869)
,p_event_id=>wwv_flow_api.id(3579252702947869)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P65_TECH_PCT,P65_COMM_PCT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3580734507947869)
,p_event_id=>wwv_flow_api.id(3579252702947869)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P65_TECH_PCT,P65_COMM_PCT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3580255343947869)
,p_event_id=>wwv_flow_api.id(3579252702947869)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P65_TECH_PCT,P65_COMM_PCT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3581177912947869)
,p_name=>'Check PCT DA'
,p_event_sequence=>230
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P65_TECH_PCT,P65_COMM_PCT'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'Number(apex.item("P65_TECH_PCT").getValue()) + Number(apex.item("P65_COMM_PCT").getValue()) != 100  '
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3581632137947870)
,p_event_id=>wwv_flow_api.id(3581177912947869)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Total Commercial% and Technical% must be 100. '
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3582161794947870)
,p_event_id=>wwv_flow_api.id(3581177912947869)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P65_COMM_PCT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3577509733947868)
,p_name=>'Close Comment DA'
,p_event_sequence=>240
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3552107156947852)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3577958720947868)
,p_event_id=>wwv_flow_api.id(3577509733947868)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(424270968574686466)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3578333511947868)
,p_name=>'Close Comment2 DA'
,p_event_sequence=>250
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(424270968574686466)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3578847798947868)
,p_event_id=>wwv_flow_api.id(3578333511947868)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(424270968574686466)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3559410867947860)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize Scoping Appendix A'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    scope_id,',
'    scope_code,',
'    dp_item_id,',
'    NVL(project_name, (select PROJECT_NAME from project where PROJECT_NUMBER = dp_scoping_a.project_number) ) project_name,',
'    project_code,',
'    project_number,',
'    provision_of_services,',
'    to_char(date_required,''DD-MON-YYYY'') date_required, ',
'    main_category_id,',
'    category_id,',
'    sub_category_id,',
'    rfp_ref_number,',
'    location_of_work,',
'    language_of_work,',
'    dct_representatives_and_support,',
'    introduction,',
'    about_dct,',
'    background_and_services_required,',
'    to_char(expected_start_date,''DD-Mon-YYYY'')   expected_start_date,',
'    to_char(expected_end_date,''DD-Mon-YYYY'')   expected_end_date,',
'    duration_comments,',
'    to_char(tender_start_date,''DD-Mon-YYYY'') tender_start_date,',
'    to_char(tender_end_date,''DD-Mon-YYYY'')   tender_end_date,',
'    technical_submission_id,    ',
'    bafo_negotiation_id,',
'    SELECTION_CRITERIA,',
'    scope_of_services,',
'    intellectual_property_copyrights,',
'    reporting_communication_requirements,',
'    added_value_offerings,',
'    created_by,',
'    updated_by,',
'    to_char(creation_date,''DD-MON-YYYY HH:MIPM'') creation_date,',
'    to_char(updated_date,''DD-MON-YYYY HH:MIPM'') updated_date,',
'    APPROVAL_STATUS,',
'    REVIEW_STATUS,',
'    template_id,',
'    template_id template_id_H,',
'    to_char(EXPECTED_CONTRACT_START_DATE,''DD-Mon-YYYY'')  EXPECTED_CONTRACT_START_DATE,',
'    to_char(EXPECTED_CONTRACT_END_DATE,''DD-Mon-YYYY'')    EXPECTED_CONTRACT_END_DATE,',
'    COMM_PCT,',
'    TECH_PCT',
'INTO',
'    :P65_scope_id,',
'    :P65_scope_code,',
'    :P65_dp_item_id,',
'    :P65_project_name,',
'    :P65_project_code,',
'    :P65_project_number,',
'    :P65_provision_of_services,',
'    :P65_date_required,',
'    :P65_main_category_id,',
'    :P65_category_id,',
'    :P65_sub_category_id,',
'    :P65_rfp_ref_number,',
'    :P65_location_of_work,',
'    :P65_language_of_work,',
'    :P65_dct_representatives_and_support,',
'    :P65_introduction,',
'    :P65_about_dct,',
'    :P65_background_and_services_required,',
'    :P65_expected_start_date,',
'    :P65_expected_end_date,',
'    :P65_duration_comments,',
'    :P65_tender_start_date,',
'    :P65_tender_end_date,',
'    :P65_technical_submission_id,',
'    :P65_bafo_negotiation_id,',
'    :P65_SELECTION_CRITERIA,',
'    :P65_scope_of_services,',
'    :P65_intellectual_property_copyrights,',
'    :P65_reporting_communication_req,',
'    :P65_added_value_offerings,',
'    :P65_created_by,',
'    :P65_updated_by,',
'    :P65_creation_date,',
'    :P65_updated_date,',
'    :P65_APPROVAL_STATUS,',
'    :P65_REVIEW_STATUS,',
'    :P65_TEMPLATE,',
'    :P65_TEMPLATE_ID,',
'    :P65_EXPECTED_CONTRACT_START_DATE,',
'    :P65_EXPECTED_CONTRACT_END_DATE,',
'    :P65_COMM_PCT,',
'    :P65_TECH_PCT',
'FROM',
'    dp_scoping_a',
'WHERE scope_id = :P65_scope_id  ;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3012553020758548)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize Cashflow'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT     line_id,',
'    budget_allocation_plan_id,',
'    accounting_year,',
'    multi_year_yn,',
'    distribution_date,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    project_name_new,',
'    task_number_new,',
'    expenditure_type_new,',
'    entity_code,',
'    cost_center,',
'    budget_groub_code,',
'    gl_account,',
'    activity,',
'    future1,',
'    future2,',
'    entity_code_new,',
'    cost_center_new,',
'    budget_groub_code_new,',
'    gl_account_new,',
'    activity_new,',
'    future1_new,',
'    future2_new,',
'    allocated_budget,',
'    line_type,',
'--    total_cf,',
'    note,',
'    status,',
'--    final_status_on,',
'    source,',
'    request_id,',
'--    request_line_id,',
'    initiative_id,',
'    initiative_new_name,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on',
'into ',
'    :P65_LINE_ID,',
'    :P65_BUDGET_ALLOCATION_PLAN_ID,',
'    :P65_ACCOUNTING_YEAR,',
'    :P65_MULTI_YEAR_YN,',
'    :P65_DISTRIBUTION_DATE,',
'    :P65_PROJECT_NUMBER_1,',
'    :P65_TASK_NUMBER,',
'    :P65_EXPENDITURE_TYPE,',
'    :P65_NEW_PROJECT_NAME,',
'    :P65_NEW_TASK_NUMBER,',
'    :P65_NEW_EXPENDITURE_TYPE,',
'    :P65_ENTITY_CODE,',
'    :P65_COST_CENTER,',
'    :P65_BUDGET_GROUB_CODE,',
'    :P65_gl_account,',
'    :P65_activity,',
'    :P65_future1,',
'    :P65_future2,',
'    :P65_entity_code_new,',
'    :P65_cost_center_new,',
'    :P65_budget_groub_code_new,',
'    :P65_gl_account_new,',
'    :P65_activity_new,',
'    :P65_future1_new,',
'    :P65_future2_new,',
'    :P65_ALLOCATED_BUDGET,',
'    :P65_LINE_TYPE,',
'    :P65_NOTE,',
'    :P65_STATUS,',
'    :P65_SOURCE,',
'    :P65_REQUEST_ID,',
'    :P65_INITIATIVE_ID,',
'    :P65_INITIATIVE_NEW_NAME,',
'    :P65_CREATED_BY,',
'    :P65_created_on,',
'    :P65_updated_by,',
'    :P65_updated_on',
'FROM    cashflow_lines',
'where request_id = :P65_DP_ITEM_ID;   '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3559771598947861)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Scoping Appendix A Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UPDATE dp_scoping_a',
'SET ',
'    provision_of_services = :P65_provision_of_services,',
'    date_required = to_date(:P65_date_required,''dd-Mon-YYYY''),',
' --   rfp_ref_number = :P65_rfp_ref_number,',
'    location_of_work = :P65_location_of_work,',
'    language_of_work = :P65_language_of_work,',
'    dct_representatives_and_support = :P65_dct_representatives_and_support ,',
'    introduction = :P65_introduction,',
'    about_dct = :P65_about_dct ,',
'    background_and_services_required = :P65_background_and_services_required ,',
'    expected_start_date = to_date(:P65_expected_start_date,''dd-Mon-YYYY''),',
'    expected_end_date = to_date(:P65_expected_end_date,''dd-Mon-YYYY''),',
'    duration_comments = :P65_duration_comments ,',
'    tender_start_date = to_date(:P65_tender_start_date,''dd-Mon-YYYY''),',
'    tender_end_date = to_date(:P65_tender_end_date,''dd-Mon-YYYY''),',
'    technical_submission_id = :P65_technical_submission_id ,',
'    bafo_negotiation_id = :P65_bafo_negotiation_id ,',
'    SELECTION_CRITERIA = :P65_SELECTION_CRITERIA,',
'    scope_of_services = :P65_scope_of_services ,',
'    intellectual_property_copyrights = :P65_intellectual_property_copyrights ,',
'    reporting_communication_requirements = :P65_REPORTING_COMMUNICATION_REQ ,',
'    added_value_offerings = :P65_added_value_offerings,',
'    EXPECTED_CONTRACT_START_DATE = :P65_EXPECTED_CONTRACT_START_DATE,',
'    EXPECTED_CONTRACT_END_DATE = :P65_EXPECTED_CONTRACT_END_DATE,',
'    COMM_PCT = :P65_COMM_PCT,',
'    TECH_PCT = :P65_TECH_PCT',
'where  scope_id = :P65_scope_id;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
