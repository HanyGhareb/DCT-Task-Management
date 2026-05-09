prompt --application/pages/page_00071
begin
--   Manifest
--     PAGE: 00071
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
 p_id=>71
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Scoping Document Details'
,p_alias=>'SCOPING-DOCUMENT-DETAILS'
,p_step_title=>'Scoping Document Details'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(99715471933410727)
,p_page_template_options=>'#DEFAULT#'
,p_read_only_when_type=>'ALWAYS'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230209172135'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(83039609868022736)
,p_plug_name=>'APPENDIX A - SCOPE OF WORK'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365606000046374665)
,p_plug_name=>'APPENDIX A - SCOPE OF WORK'
,p_parent_plug_id=>wwv_flow_api.id(83039609868022736)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99730028608410735)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(363828296991926115)
,p_plug_name=>'Project Overview'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,1) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365881573579201290)
,p_plug_name=>'Project Overview'
,p_parent_plug_id=>wwv_flow_api.id(363828296991926115)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(229864590351110120)
,p_plug_name=>'DCT_REPRESENTATIVES_AND_SUPPORT REGION'
,p_parent_plug_id=>wwv_flow_api.id(365881573579201290)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(363828570905926118)
,p_plug_name=>'Requirements Overview'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,2) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365881635403201291)
,p_plug_name=>'Requirements Overview'
,p_parent_plug_id=>wwv_flow_api.id(363828570905926118)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365756777857221014)
,p_plug_name=>'Enquires and Contact Procedure'
,p_parent_plug_id=>wwv_flow_api.id(365881635403201291)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
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
 p_id=>wwv_flow_api.id(365756839658221015)
,p_plug_name=>'Enquires and Contact Procedure Report'
,p_parent_plug_id=>wwv_flow_api.id(365756777857221014)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where DP_SCOPING_A_ID = :P71_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(365757088311221017)
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
,p_internal_uid=>579041120700405649
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64145642698137560)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64145303254137560)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64144927487137560)
,p_db_column_name=>'NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64144450538137560)
,p_db_column_name=>'POSITION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Position'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64144062902137559)
,p_db_column_name=>'EMAIL'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64143647290137559)
,p_db_column_name=>'PHONE_NO'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Phone No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64143273378137559)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64142906384137559)
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
 p_id=>wwv_flow_api.id(64142467077137559)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64142041381137558)
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
 p_id=>wwv_flow_api.id(365795274915975697)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1491423'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'NAME:POSITION:EMAIL:PHONE_NO:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365783579230990479)
,p_plug_name=>'Objectives and Benefits to DCT'
,p_parent_plug_id=>wwv_flow_api.id(365881635403201291)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,61) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365783730165990481)
,p_plug_name=>'Objectives and Benefits to DCT Report'
,p_parent_plug_id=>wwv_flow_api.id(365783579230990479)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where DP_SCOPING_A_ID = :P71_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(365783850522990482)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Objectives and Benefits to DCT available'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>579067882912175114
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64140258638137557)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64139858998137557)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64139464367137557)
,p_db_column_name=>'RECORD_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Objective / Benefit'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(63818414216137362)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64139072540137556)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64138674268137556)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64138278748137556)
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
 p_id=>wwv_flow_api.id(64137847588137556)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64137492756137556)
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
 p_id=>wwv_flow_api.id(64137051835137555)
,p_db_column_name=>'DELETED_FLAG'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Deleted Flag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(365805689275936631)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1491473'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'RECORD_TYPE:DESCRIPTION:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(363828912056926122)
,p_plug_name=>'Timelines'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,3) = ''Y'' and',
'(:P71_EXPECTED_START_DATE is not null or ',
':P71_EXPECTED_END_DATE is not null or ',
':P71_TENDER_START_DATE is not null or ',
':P71_EXPECTED_CONTRACT_START_DATE is not null or ',
':P71_DURATION_COMMENTS is not null)'))
,p_plug_read_only_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_read_only_when=>'IS_PBP_EMP'
,p_plug_read_only_when2=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365881765155201292)
,p_plug_name=>'Timelines'
,p_parent_plug_id=>wwv_flow_api.id(363828912056926122)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'ALWAYS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365734755588260076)
,p_plug_name=>'Submission Information'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,4) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365735186321260080)
,p_plug_name=>'Scope of Services'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,5) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(230676630575026442)
,p_plug_name=>'Guidance'
,p_parent_plug_id=>wwv_flow_api.id(365735186321260080)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(230676827385026444)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(365735186321260080)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365735542735260084)
,p_plug_name=>'Required Deliverables'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,6) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365785180574990495)
,p_plug_name=>'Required Deliverables Report'
,p_parent_plug_id=>wwv_flow_api.id(365735542735260084)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where DP_SCOPING_A_ID = :P71_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(365785287861990496)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Deliverables Available.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_control_break=>'N'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>579069320251175128
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64093842021137529)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64093482088137528)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64093052521137528)
,p_db_column_name=>'DELIVERABLE_DESCRIPTION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Deliverable Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64092716726137528)
,p_db_column_name=>'DELIVERABLE_WEIGHT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64092266290137528)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64091859226137528)
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
 p_id=>wwv_flow_api.id(64091444486137527)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64091101670137527)
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
 p_id=>wwv_flow_api.id(64097512505137530)
,p_db_column_name=>'FILENAME'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64097084572137530)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64096692219137530)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64096240086137530)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64095908370137530)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'File Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64095501393137529)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64095038808137529)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:DP_SCOPING_A_DELIVERABLES:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:FILE_UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64094727295137529)
,p_db_column_name=>'DATE_DEFINED_YN'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Milestone Defined ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64094290440137529)
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
 p_id=>wwv_flow_api.id(365824323101125416)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1491933'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DELIVERABLE_DESCRIPTION:DATE_DEFINED_YN:MILESTONE_DUE_DATE:FILENAME:FILE_COMMENTS:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365735955424260088)
,p_plug_name=>'Performance Measurements'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,7) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365786350140990507)
,p_plug_name=>'Performance Measurements Report'
,p_parent_plug_id=>wwv_flow_api.id(365735955424260088)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where DP_SCOPING_A_ID = :P71_SCOPE_ID',
'  order by KPI_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(365786467906990508)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Performance Measurements available.'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>579070500296175140
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64187194406137586)
,p_db_column_name=>'KPI_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Kpi Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64186790592137586)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64186369997137586)
,p_db_column_name=>'KPI_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'KPI Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64185957253137586)
,p_db_column_name=>'KPI_DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64185561708137585)
,p_db_column_name=>'TARGET_VALUE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Target Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64185134320137585)
,p_db_column_name=>'TARGET_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Target Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64184794856137585)
,p_db_column_name=>'TREND_DIRECTION'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Trend Direction'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64184349690137585)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64184024842137585)
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
 p_id=>wwv_flow_api.id(64183601814137584)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64183205294137584)
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
 p_id=>wwv_flow_api.id(64188018270137587)
,p_db_column_name=>'METHOD_OF_MEASURE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Method Of Measure'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64187604961137586)
,p_db_column_name=>'SERVICE_CREDIT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Service Credit'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(365833152950099862)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1491012'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'KPI_NAME:KPI_DESCRIPTION:METHOD_OF_MEASURE:SERVICE_CREDIT:TARGET_VALUE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365736390321260092)
,p_plug_name=>'Supplier Responsibilities'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,8) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365787646946990520)
,p_plug_name=>'Supplier Responsibilities Report'
,p_parent_plug_id=>wwv_flow_api.id(365736390321260092)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where DP_SCOPING_A_ID = :P71_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(365787760794990521)
,p_max_row_count=>'1000000'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>579071793184175153
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64134117038137554)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64133703732137553)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64133235343137553)
,p_db_column_name=>'RESPONSIBILITY_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Responsibility Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64132841375137553)
,p_db_column_name=>'RESPONSIBILITY_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Responsibility Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64132446703137553)
,p_db_column_name=>'DFF1'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Dff1'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64132095556137553)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64131641661137552)
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
 p_id=>wwv_flow_api.id(64131299170137552)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64130883296137552)
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
 p_id=>wwv_flow_api.id(365843143759078907)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1491535'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'RESPONSIBILITY_NAME:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365736728243260096)
,p_plug_name=>'Proposal Submission Requirements'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,9) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365834668436091782)
,p_plug_name=>'Proposal Submission Requirements Report'
,p_parent_plug_id=>wwv_flow_api.id(365736728243260096)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where DP_SCOPING_A_ID = :P71_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(365834716199091783)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'Noting Available'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>579118748588276415
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64127917207137550)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64127481217137550)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64127062786137550)
,p_db_column_name=>'REQUIREMENT_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Requirement Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64126687659137550)
,p_db_column_name=>'REQUIREMENT_DESC'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64126302263137549)
,p_db_column_name=>'REQUIREMENT_TARGET'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Requirement Target'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64125844115137549)
,p_db_column_name=>'REQUIREMENT_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Requirement Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64125486855137549)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64125041227137549)
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
 p_id=>wwv_flow_api.id(64124679144137549)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64124305308137548)
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
 p_id=>wwv_flow_api.id(365855628333971940)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1491601'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUIREMENT_NAME:REQUIREMENT_DESC:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365737205545260100)
,p_plug_name=>'Security Requirements'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>100
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,10) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365835999845091795)
,p_plug_name=>'Security Requirements Report'
,p_parent_plug_id=>wwv_flow_api.id(365737205545260100)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where DP_SCOPING_A_ID =  :P71_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(365836007164091796)
,p_max_row_count=>'1000000'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>579120039553276428
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64121322226137547)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64120850220137546)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64120435127137546)
,p_db_column_name=>'SECURITY_REQ'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Security Requirement'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64120081816137546)
,p_db_column_name=>'PRIORITY'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(48255921784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64119644690137546)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64119311762137546)
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
 p_id=>wwv_flow_api.id(64118903460137545)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64118447480137545)
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
 p_id=>wwv_flow_api.id(365859152615955485)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1491659'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECURITY_REQ:PRIORITY:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365737558450260104)
,p_plug_name=>'Data Capture Requirements'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>110
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,11) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365837088095091806)
,p_plug_name=>'Data Capture Requirements Report'
,p_parent_plug_id=>wwv_flow_api.id(365737558450260104)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where DP_SCOPING_A_ID = :P71_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(365837121994091807)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Data Capture Requirements Defined'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>579121154383276439
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64115464459137543)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64115129586137543)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64114686675137543)
,p_db_column_name=>'DATA_REQUIREMENT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Data Requirement'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64114233889137543)
,p_db_column_name=>'DESCRIPTIONS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64113869342137543)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64113497998137542)
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
 p_id=>wwv_flow_api.id(64113065960137542)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64112657171137540)
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
 p_id=>wwv_flow_api.id(365863214909908907)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1491717'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_A_ID:DATA_REQUIREMENT:DESCRIPTIONS:CREATED_BY:CREATION_DATE:UPDATED_BY:UPDATED_DATE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365738003499260108)
,p_plug_name=>'Intellectual Property/Copyrights of Work'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>120
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,12) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365738311340260112)
,p_plug_name=>'Reporting & Communication Requirements'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>130
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,13) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365738738830260116)
,p_plug_name=>'Added Value Offerings'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>140
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,14) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365739134859260120)
,p_plug_name=>'Attachments and Supporting Documents'
,p_parent_plug_id=>wwv_flow_api.id(365606000046374665)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>150
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P71_TEMPLATE_ID,15) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(494510863517902194)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(365739134859260120)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(494617151175467661)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(494510863517902194)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where SCOPING_ID = :P71_SCOPE_ID',
'    order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(494617293334467662)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>707901325723652294
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64172989981137577)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64172594728137577)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64172228315137577)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::P56_ID,P56_PAGE_FROM:#ID#,28'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64171811418137577)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64171392201137576)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64171002054137576)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64170628623137576)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64170174337137576)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64169735057137575)
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
 p_id=>wwv_flow_api.id(64169428558137575)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64168935787137575)
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
 p_id=>wwv_flow_api.id(64168564345137575)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64168168258137574)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64167776166137574)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64167356081137574)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:DP_SCOPING_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64174135352137578)
,p_db_column_name=>'SCOPING_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Scoping Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64173777341137578)
,p_db_column_name=>'SCOPING_APPENDIX'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Scoping Appendix'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64173398111137577)
,p_db_column_name=>'SCOPING_COMPONENT'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Scoping Component'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(494642806038182829)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1491170'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368083698176017108)
,p_plug_name=>'Demand Planning Item Details'
,p_parent_plug_id=>wwv_flow_api.id(83039609868022736)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(83039784403022737)
,p_plug_name=>'APPENDIX B - TECHNICAL EVALUATION CRITERIA'
,p_icon_css_classes=>'fa-bold'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365856006487487689)
,p_plug_name=>'APPENDIX B - TECHNICAL EVALUATION CRITERIA'
,p_parent_plug_id=>wwv_flow_api.id(83039784403022737)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99730028608410735)
,p_plug_display_sequence=>160
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365999369392334012)
,p_plug_name=>'Technical Criteria - Compliance with SOW'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 16  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368768514856628121)
,p_plug_name=>'Technical Criteria 1 - Compliance with SOW Report'
,p_parent_plug_id=>wwv_flow_api.id(365999369392334012)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'    where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_16',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_16,P28_DP_ITEM_ID,P28_TEMPLATE_ID,P28_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368768649747628122)
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
,p_internal_uid=>582052682136812754
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63995392811137466)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63994993936137466)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63994617403137466)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63994216745137466)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63993778562137465)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63993406793137465)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63993002912137465)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63992608587137465)
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
 p_id=>wwv_flow_api.id(63992205263137465)
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
 p_id=>wwv_flow_api.id(63991746275137464)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63991370669137464)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63995831119137466)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(368874022992210014)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492930'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365999484047334013)
,p_plug_name=>'Technical Criteria - Concept and Program Development  '
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 17  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368770879856628145)
,p_plug_name=>'Technical Criteria - Concept and Program Development Report'
,p_parent_plug_id=>wwv_flow_api.id(365999484047334013)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_17',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_17,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368770973623628146)
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
,p_internal_uid=>582055006012812778
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63989197692137463)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63988811659137463)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63988415096137462)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63987974651137462)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63987601549137462)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63987192079137462)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63986810147137462)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63986344775137461)
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
 p_id=>wwv_flow_api.id(63985994329137461)
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
 p_id=>wwv_flow_api.id(63985564735137461)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63985171797137461)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63989576411137463)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(368907513509839409)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492992'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365999740096334015)
,p_plug_name=>'Technical Criteria 3- Agency''s Experience '
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 18  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368926722176955312)
,p_plug_name=>'Technical Criteria - Agency''s Experience'
,p_parent_plug_id=>wwv_flow_api.id(365999740096334015)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_18',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID,P71_TEMPLATE_COMPOENET_ID_18'
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
 p_id=>wwv_flow_api.id(368926796518955313)
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
,p_internal_uid=>582210828908139945
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63982942059137459)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63982545173137459)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63982227652137459)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63981815928137459)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63981382239137459)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63980982989137458)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63980541821137458)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63980190230137458)
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
 p_id=>wwv_flow_api.id(63979748008137458)
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
 p_id=>wwv_flow_api.id(63979369777137458)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63978974480137458)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63983349200137460)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369097367695566418)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1493054'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365999892051334017)
,p_plug_name=>'Technical Criteria  - Methodology and Technical Approach'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 19  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368928175412955327)
,p_plug_name=>'Technical Criteria - Methodology and Technical Approach Report'
,p_parent_plug_id=>wwv_flow_api.id(365999892051334017)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_19',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_19,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368928316255955328)
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
,p_internal_uid=>582212348645139960
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63976779974137456)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63976397921137456)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63975969418137456)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63975555725137455)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63975193841137455)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63974827192137455)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63974388864137455)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63973959542137455)
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
 p_id=>wwv_flow_api.id(63973567887137455)
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
 p_id=>wwv_flow_api.id(63973189304137454)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63972792589137454)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63977183915137456)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369098030952566171)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1493116'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(366000141809334019)
,p_plug_name=>'Technical Criteria  - Other Considerations'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 20  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368929716279955342)
,p_plug_name=>'Technical Criteria 5 - Other Considerations Report'
,p_parent_plug_id=>wwv_flow_api.id(366000141809334019)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_20',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_20,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368929774086955343)
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
,p_internal_uid=>582213806476139975
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63970607697137451)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63970165226137451)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63969745720137450)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63969341059137450)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63968949414137450)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63968557561137450)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63968206768137450)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63967735531137450)
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
 p_id=>wwv_flow_api.id(63967342153137449)
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
 p_id=>wwv_flow_api.id(63966995023137449)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63966538140137449)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63970975586137451)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369098606769565932)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1493178'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368930975217955355)
,p_plug_name=>'Technical Criteria - Corporate experience and resources'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 81  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368931291323955358)
,p_plug_name=>'Technical Criteria - Corporate experience and resources Report'
,p_parent_plug_id=>wwv_flow_api.id(368930975217955355)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_81',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_81,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368931434061955359)
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
,p_internal_uid=>582215466451139991
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63964425181137447)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63963950830137447)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63963578199137447)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63963190801137447)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63962761272137447)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63962353187137447)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63961938998137446)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63961579102137446)
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
 p_id=>wwv_flow_api.id(63961155842137446)
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
 p_id=>wwv_flow_api.id(63960766946137446)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63960333250137446)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63964790694137448)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369099226839565693)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1493240'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368947502765910221)
,p_plug_name=>'Technical Criteria - Management approach'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 82  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368947771602910224)
,p_plug_name=>'Technical Criteria - Management approach Report'
,p_parent_plug_id=>wwv_flow_api.id(368947502765910221)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_82',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_82,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368947960877910225)
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
,p_internal_uid=>582231993267094857
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63958211319137444)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63957759864137444)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63957392657137444)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63956953610137443)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63956573169137443)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63956216137137443)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63955749620137443)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63955337051137443)
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
 p_id=>wwv_flow_api.id(63955015025137442)
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
 p_id=>wwv_flow_api.id(63954541680137442)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63954179309137442)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63958563080137444)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369099820663565453)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1493302'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368949143651910237)
,p_plug_name=>'Technical Criteria - Project Solution'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 83  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368949397326910240)
,p_plug_name=>'Technical Criteria - Project Solution Report'
,p_parent_plug_id=>wwv_flow_api.id(368949143651910237)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_83',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_83,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368949494844910241)
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
,p_internal_uid=>582233527234094873
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63952009704137440)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63951610537137440)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63951190514137440)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63950823453137440)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63950405430137440)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63949944372137440)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63949583423137439)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63949225533137439)
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
 p_id=>wwv_flow_api.id(63948756288137439)
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
 p_id=>wwv_flow_api.id(63948397837137439)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63947997848137439)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63952414513137441)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369100373193565213)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1493364'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368950752000910253)
,p_plug_name=>'Technical Criteria - Detailed project plan, timeline and deliverables, to include quality assurance program'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 84  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368950996283910256)
,p_plug_name=>'Technical Criteria - Detailed project plan, timeline and deliverables, to include quality assurance program Report'
,p_parent_plug_id=>wwv_flow_api.id(368950752000910253)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_84',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_84,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368951152760910257)
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
,p_internal_uid=>582235185150094889
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63945810270137437)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63945375354137437)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63944957162137437)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63944541784137436)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63944195032137436)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63943816438137436)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63943386602137436)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63942975719137436)
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
 p_id=>wwv_flow_api.id(63942594945137436)
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
 p_id=>wwv_flow_api.id(63942173145137435)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63941780081137435)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63946223497137437)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369101013354564967)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1493426'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368967582589870519)
,p_plug_name=>'Technical Criteria - Project completion report'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>100
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 85  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368967944348870522)
,p_plug_name=>'Technical Criteria - Project completion report report'
,p_parent_plug_id=>wwv_flow_api.id(368967582589870519)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_85',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_85,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368968006302870523)
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
,p_internal_uid=>582252038692055155
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64088254968137524)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64087925548137524)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64087478154137523)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64087100483137523)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64086718777137523)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64086253431137523)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64085916207137523)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64085505767137522)
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
 p_id=>wwv_flow_api.id(64085102354137522)
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
 p_id=>wwv_flow_api.id(64084693054137522)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64084298112137522)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64088674139137524)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369101642013564727)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492001'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368969205239870535)
,p_plug_name=>'Technical Criteria - Innovation'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>110
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 86  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368969546646870538)
,p_plug_name=>'Technical Criteria - Innovation report'
,p_parent_plug_id=>wwv_flow_api.id(368969205239870535)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_86',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_86,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368969610981870539)
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
,p_internal_uid=>582253643371055171
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64082038086137520)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64081659072137520)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64081272454137520)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64080868056137520)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64080510674137519)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64080094117137519)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64079676843137519)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64079280448137519)
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
 p_id=>wwv_flow_api.id(64078860926137519)
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
 p_id=>wwv_flow_api.id(64078514511137518)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64078034468137518)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64082465328137520)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369102164981564485)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492063'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368970814070870551)
,p_plug_name=>'Technical Criteria - Knowledge Transfer'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>120
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 87  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368971072551870554)
,p_plug_name=>'Technical Criteria - Knowledge Transfer report'
,p_parent_plug_id=>wwv_flow_api.id(368970814070870551)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_87',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_87,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368971225622870555)
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
,p_internal_uid=>582255258012055187
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64075888461137517)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64075468721137516)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64075065355137516)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64074635361137516)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64074256521137516)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64073896284137516)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64073458601137516)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64073032861137515)
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
 p_id=>wwv_flow_api.id(64072644669137515)
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
 p_id=>wwv_flow_api.id(64072326476137515)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64071923813137515)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64076263315137517)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369102843208564243)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492125'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368989393626843117)
,p_plug_name=>'Technical Criteria - Stakeholder Engagement and Communication'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>130
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 88  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368989696241843120)
,p_plug_name=>'Technical Criteria - Stakeholder Engagement and Communication report'
,p_parent_plug_id=>wwv_flow_api.id(368989393626843117)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_88',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_88,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368989837180843121)
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
,p_internal_uid=>582273869570027753
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63939572324137434)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63939189364137433)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63938807840137433)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63938369725137433)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63937987994137433)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63937535229137433)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63937134142137432)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63936796137137432)
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
 p_id=>wwv_flow_api.id(63936394583137432)
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
 p_id=>wwv_flow_api.id(63935952045137432)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63935577710137432)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63939954433137434)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369103407654563996)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1493488'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368990985809843133)
,p_plug_name=>'Technical Criteria - Social and Environmental Value'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>140
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 89  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368991352494843136)
,p_plug_name=>'Technical Criteria - Social and Environmental Value report'
,p_parent_plug_id=>wwv_flow_api.id(368990985809843133)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_89',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_89,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368991456014843137)
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
,p_internal_uid=>582275488404027769
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64069638074137513)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64069254002137513)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64068842534137513)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64068470524137513)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64068085369137512)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64067692781137512)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64067285915137512)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64066876783137512)
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
 p_id=>wwv_flow_api.id(64066616599137512)
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
 p_id=>wwv_flow_api.id(64066147083137511)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64065739096137511)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64070071047137513)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369104054677563757)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492186'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368992629302843149)
,p_plug_name=>'Technical Criteria - Value added features'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>150
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 90  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(368992890484843152)
,p_plug_name=>'Technical Criteria - Value added features report'
,p_parent_plug_id=>wwv_flow_api.id(368992629302843149)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_90',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_90,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(368993018762843153)
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
,p_internal_uid=>582277051152027785
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64063598207137510)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64063199334137510)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64062822265137509)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64062346549137509)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64061936508137509)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64061540837137509)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64061222918137509)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64060745730137508)
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
 p_id=>wwv_flow_api.id(64060384393137508)
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
 p_id=>wwv_flow_api.id(64060020613137508)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64059541438137508)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64063958423137510)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369104631737563515)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492248'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369008588577823715)
,p_plug_name=>'Technical Criteria - Proof-of-Concept / Sample / Solution / Presentation'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>160
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 91  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369008881276823718)
,p_plug_name=>'Technical Criteria - Value added features report'
,p_parent_plug_id=>wwv_flow_api.id(369008588577823715)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_91',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_91,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(369008982521823719)
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
,p_internal_uid=>582293014911008351
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64057362252137506)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64056993283137506)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64056629928137506)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64056147329137506)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64055804138137505)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64055340332137505)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64054992736137505)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64054551518137505)
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
 p_id=>wwv_flow_api.id(64054151770137505)
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
 p_id=>wwv_flow_api.id(64053792819137505)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64053397510137504)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64057777541137506)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369105186678563276)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492310'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:WEGHT:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369010260147823731)
,p_plug_name=>'Technical Criteria - Company Overview and Management Approach'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>170
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 92  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369010528229823734)
,p_plug_name=>'Technical Criteria - Company Overview and Management Approach report'
,p_parent_plug_id=>wwv_flow_api.id(369010260147823731)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_92',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_92,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(369010650845823735)
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
,p_internal_uid=>582294683235008367
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64051220310137503)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64050755562137503)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64050334184137502)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64049972851137502)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64049580036137502)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64049215198137502)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64048741425137502)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64048384059137502)
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
 p_id=>wwv_flow_api.id(64047950789137501)
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
 p_id=>wwv_flow_api.id(64047563782137501)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64047229211137501)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64051564013137503)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369105845331563035)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492372'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369011848620823747)
,p_plug_name=>'Technical Criteria - Program Management and Concept'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>180
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 93  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369012155567823750)
,p_plug_name=>'Technical Criteria - Program Management and Concept report'
,p_parent_plug_id=>wwv_flow_api.id(369011848620823747)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_93',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_93,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(369012242194823751)
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
,p_internal_uid=>582296274584008383
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64045009710137495)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64044624731137495)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64044229599137495)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64043825100137494)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64043404354137494)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64043008370137494)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64042548928137494)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64042176516137494)
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
 p_id=>wwv_flow_api.id(64041775713137493)
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
 p_id=>wwv_flow_api.id(64041350176137493)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64040940956137493)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64045413763137495)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369106371030562792)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492434'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369030697044717013)
,p_plug_name=>'Technical Criteria - Business Requirement Compliance'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>190
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 94  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369031039375717016)
,p_plug_name=>'Technical Criteria - Business Requirement Compliance report'
,p_parent_plug_id=>wwv_flow_api.id(369030697044717013)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_94',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_94,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(369031103399717017)
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
,p_internal_uid=>582315135788901649
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64038773170137491)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64038383061137491)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64037961506137491)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64037591130137491)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64037179206137491)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64036807010137490)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64036376788137490)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64035954300137490)
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
 p_id=>wwv_flow_api.id(64035616765137490)
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
 p_id=>wwv_flow_api.id(64035186586137489)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64034815468137489)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64039170157137492)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369106966707562552)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492496'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369032281573717029)
,p_plug_name=>'Technical Criteria - Technical Capability (Qualitative)'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>200
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 96  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369032576537717032)
,p_plug_name=>'Technical Criteria - Technical Capability (Qualitative) report'
,p_parent_plug_id=>wwv_flow_api.id(369032281573717029)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_96',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_96,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(369032724928717033)
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
,p_internal_uid=>582316757317901665
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64032561174137487)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64032228497137487)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64031761899137487)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64031347518137487)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64030984151137487)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64030558606137486)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64030151793137486)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64029831575137486)
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
 p_id=>wwv_flow_api.id(64029428118137485)
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
 p_id=>wwv_flow_api.id(64028990904137485)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64028616326137485)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64032965978137488)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369107651730562293)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492558'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369033888116717045)
,p_plug_name=>'Technical Criteria - Technical Capability (Quantitative)'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>210
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 97  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369034178326717048)
,p_plug_name=>'Technical Criteria - Technical Capability (Quantitative) report'
,p_parent_plug_id=>wwv_flow_api.id(369033888116717045)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_97',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_97,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(369034286272717049)
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
,p_internal_uid=>582318318661901681
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64026334199137483)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64025938750137483)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64025613620137483)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64025166491137483)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64024732950137483)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64024378902137482)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64023959493137482)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64023597597137482)
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
 p_id=>wwv_flow_api.id(64023153440137482)
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
 p_id=>wwv_flow_api.id(64022736810137482)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64022412027137482)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64026743223137484)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369108232506562035)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492620'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369055240429683511)
,p_plug_name=>'Technical Criteria - Team Capability'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>220
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 98  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369055790261683517)
,p_plug_name=>'Technical Criteria - Technical Criteria - Team Capability Report'
,p_parent_plug_id=>wwv_flow_api.id(369055240429683511)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_98',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_98,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(369055931884683518)
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
,p_internal_uid=>582339964273868150
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64020142322137480)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64019777248137480)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64019412738137480)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64018941036137479)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64018579601137479)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64018138145137479)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64017737218137479)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64017374817137479)
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
 p_id=>wwv_flow_api.id(64016976896137478)
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
 p_id=>wwv_flow_api.id(64016556321137478)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64016133076137478)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64020532734137480)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369108892402561799)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492682'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369055487355683514)
,p_plug_name=>'Technical Criteria - Reporting and Delivery'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>230
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 99  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369057079260683530)
,p_plug_name=>'Technical Criteria - Reporting and Delivery Report'
,p_parent_plug_id=>wwv_flow_api.id(369055487355683514)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_99',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_99,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(369057258299683531)
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
,p_internal_uid=>582341290688868163
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64013953914137476)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64013565121137476)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64013196061137476)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64012746557137476)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64012363601137476)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64011969563137475)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64011601761137475)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64011143534137475)
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
 p_id=>wwv_flow_api.id(64010739818137475)
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
 p_id=>wwv_flow_api.id(64010354520137475)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64009979448137474)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64014350493137477)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369109499321561563)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492744'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369058435401683543)
,p_plug_name=>'Technical Criteria - Vendor Performance'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>240
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 100 ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369058668438683546)
,p_plug_name=>'Technical Criteria - Vendor Performance Report'
,p_parent_plug_id=>wwv_flow_api.id(369058435401683543)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_100',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_100,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(369058761784683547)
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
,p_internal_uid=>582342794173868179
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64007794623137473)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64007340336137473)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64006954331137473)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64006563972137472)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64006211952137472)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64005757217137472)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64005399791137472)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64004974225137472)
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
 p_id=>wwv_flow_api.id(64004584404137471)
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
 p_id=>wwv_flow_api.id(64004156420137471)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64003745867137471)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64008149977137473)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369110113876561328)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492806'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369060005491683559)
,p_plug_name=>'Technical Criteria - Tourism Experience and Resources'
,p_parent_plug_id=>wwv_flow_api.id(365856006487487689)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>250
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''B'' , :P71_TEMPLATE_ID  , 101 ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369076025206641312)
,p_plug_name=>'Technical Criteria - Tourism Experience and Resources Report'
,p_parent_plug_id=>wwv_flow_api.id(369060005491683559)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_101',
'  and DP_SCOPING_B_ID = :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
'  '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_TEMPLATE_COMPOENET_ID_101,P71_DP_ITEM_ID,P71_TEMPLATE_ID,P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(369076124970641313)
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
,p_internal_uid=>582360157359825945
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64001606326137469)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64001177022137469)
,p_db_column_name=>'DP_SCOPING_B_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping B Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64000781802137469)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64000349452137469)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Technical Criterion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63999975911137469)
,p_db_column_name=>'NOTES'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63999613604137469)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63999146197137468)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63998807710137468)
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
 p_id=>wwv_flow_api.id(63998414164137468)
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
 p_id=>wwv_flow_api.id(63997989357137468)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63997600837137468)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64001970521137470)
,p_db_column_name=>'WEGHT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Weght'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369110661350561086)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1492868'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_B_ID:COMPONENT_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:TEMPLATE_ID:DP_ITEM_ID:WEGHT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(83039861005022738)
,p_plug_name=>'APPENDIX C - COMMERCIAL EVALUATION CRITERIA'
,p_icon_css_classes=>'fa-copyright'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(366030953549587314)
,p_plug_name=>'APPENDIX C - COMMERCIAL EVALUATION CRITERIA'
,p_parent_plug_id=>wwv_flow_api.id(83039861005022738)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99730028608410735)
,p_plug_display_sequence=>260
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(366171134720433649)
,p_plug_name=>'Commercial Criterion'
,p_parent_plug_id=>wwv_flow_api.id(366030953549587314)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''C'' , :P71_TEMPLATE_ID  , 21  ) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369248322277740955)
,p_plug_name=>'Commercial Criterion 1 Report'
,p_parent_plug_id=>wwv_flow_api.id(366171134720433649)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_21',
'  and DP_SCOPING_C_ID =  :P71_SCOPE_ID',
'  and TEMPLATE_ID = :P71_TEMPLATE_ID',
'  and DP_ITEM_ID = :P71_DP_ITEM_ID',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID,P71_TEMPLATE_COMPOENET_ID_21,P71_TEMPLATE_ID,P71_DP_ITEM_ID'
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
 p_id=>wwv_flow_api.id(369248378556740956)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Commercial Criterion Available'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>582532410945925588
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63933583350137430)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63933166003137430)
,p_db_column_name=>'DP_SCOPING_C_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping C Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63932791774137430)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63932336313137429)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63931972211137429)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63931561704137429)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Criterion Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63931134663137429)
,p_db_column_name=>'NOTES'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63930762255137429)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63930394525137428)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63929934501137428)
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
 p_id=>wwv_flow_api.id(63929532929137428)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(369363470178350538)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1493548'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CRITERION_TEXT:NOTES:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(366171178325433650)
,p_plug_name=>'Commercial Criterion 2'
,p_parent_plug_id=>wwv_flow_api.id(366030953549587314)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_plug_comment=>'DP_SCOPING_UTIL.SHOW_REGION_YN(''C'' , :P29_TEMPLATE_ID  , 22  ) = ''Y'''
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(369250170154740974)
,p_plug_name=>'Commercial Criterion 2 Report'
,p_parent_plug_id=>wwv_flow_api.id(366171178325433650)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'where COMPONENT_ID = :P71_TEMPLATE_COMPOENET_ID_22',
'  and DP_SCOPING_C_ID = :P28_SCOPE_ID',
'  and TEMPLATE_ID = :P28_TEMPLATE_ID',
'  and DP_ITEM_ID = :P28_DP_ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID,P71_TEMPLATE_COMPOENET_ID_21,P28_TEMPLATE_ID,P28_DP_ITEM_ID'
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
 p_id=>wwv_flow_api.id(369250305704740975)
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
,p_internal_uid=>582534338093925607
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63928189332137426)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63927753792137426)
,p_db_column_name=>'DP_SCOPING_C_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping C Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63927378792137426)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63926981604137426)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63926613817137426)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63926141245137425)
,p_db_column_name=>'CRITERION_TEXT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Criterion Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63925809425137425)
,p_db_column_name=>'NOTES'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63925418320137425)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63924951259137425)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63924597803137425)
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
 p_id=>wwv_flow_api.id(63924169565137424)
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
 p_id=>wwv_flow_api.id(369364087322350305)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1493602'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_C_ID:COMPONENT_ID:TEMPLATE_ID:DP_ITEM_ID:CRITERION_TEXT:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(83039926603022739)
,p_plug_name=>'APPENDIX D - PRICING SCHEDULE (BOQ)'
,p_icon_css_classes=>'fa-id-card-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(640961815699484617)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(83039926603022739)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  where SCOPING_ID = :P71_SCOPE_ID',
'  and SCOPING_APPENDIX = ''D''',
'    order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(640961957858484618)
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
,p_internal_uid=>854245990247669250
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63921567144137418)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63921208809137418)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63920758160137418)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::P56_ID,P56_PAGE_FROM,P56_SCOPING_APPENDIX:#ID#,31,D'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63920417439137417)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63919950875137417)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63919537265137417)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63919203164137417)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63918794989137417)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63918388619137416)
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
 p_id=>wwv_flow_api.id(63917958594137416)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63917606329137416)
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
 p_id=>wwv_flow_api.id(63917231950137416)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63916819147137416)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63916398569137415)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63915948170137415)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:DP_SCOPING_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63922789461137419)
,p_db_column_name=>'SCOPING_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Scoping Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63922394627137418)
,p_db_column_name=>'SCOPING_APPENDIX'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Scoping Appendix'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63922019021137418)
,p_db_column_name=>'SCOPING_COMPONENT'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Scoping Component'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(640987470562199785)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1493684'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(83040083105022740)
,p_plug_name=>'Cashflow'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(366059015253594514)
,p_plug_name=>'Cashflow Details'
,p_parent_plug_id=>wwv_flow_api.id(83040083105022740)
,p_region_template_options=>'#DEFAULT#:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99730028608410735)
,p_plug_display_sequence=>280
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(230220878917786047)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(366059015253594514)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(230221686773786055)
,p_plug_name=>'&CURRENT_YEAR. Cashflow Details'
,p_parent_plug_id=>wwv_flow_api.id(366059015253594514)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LINE_ID,',
'       BUDGET_ALLOCATION_PLAN_ID,',
'       ACCOUNTING_YEAR,',
'       MULTI_YEAR_YN,',
'       DISTRIBUTION_DATE,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       PROJECT_NAME_NEW,',
'       TASK_NUMBER_NEW,',
'       EXPENDITURE_TYPE_NEW,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUB_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       ENTITY_CODE_NEW,',
'       COST_CENTER_NEW,',
'       BUDGET_GROUB_CODE_NEW,',
'       GL_ACCOUNT_NEW,',
'       ACTIVITY_NEW,',
'       FUTURE1_NEW,',
'       FUTURE2_NEW,',
'       ALLOCATED_BUDGET,',
'       BUDGET,',
'       ENCUMBERANCE,',
'       ACTUAL,',
'       nvl(JAN,0)   JAN,',
'       nvl(FEB,0)   FEB,',
'       nvl(MAR,0)   MAR,',
'       nvl(APR,0)   APR,',
'       nvl(MAY,0)   MAY,',
'       nvl(JUN,0)   JUN,',
'       nvl(JUL,0)   JUL,',
'       nvl(AUG,0)   AUG,',
'       nvl(SEP,0)   SEP,',
'       nvl(OCT,0)   OCT,',
'       nvl(NOV,0)   NOV ,',
'       nvl(DEC,0)   DEC,',
'       LINE_TYPE,',
'       TOTAL_CF,',
'       NOTE,',
'       STATUS,',
'       FINAL_STATUS_ON,',
'       SOURCE,',
'       REQUEST_ID,',
'       REQUEST_LINE_ID,',
'       INITIATIVE_ID,',
'       INITIATIVE_NEW_NAME,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       TOTAL_CF_FORMAT',
'  from CASHFLOW_LINES',
' where line_id = :P71_LINE_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_LINE_ID'
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
 p_id=>wwv_flow_api.id(83000584683676903)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>296284617072861535
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63897668337137401)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63897329490137401)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Budget Allocation Plan Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63896856973137401)
,p_db_column_name=>'ACCOUNTING_YEAR'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Accounting Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63896491939137401)
,p_db_column_name=>'MULTI_YEAR_YN'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Multi Year Yn'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63896105195137401)
,p_db_column_name=>'DISTRIBUTION_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Distribution Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63895654825137401)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63895263663137400)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63894887010137400)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63894501702137400)
,p_db_column_name=>'PROJECT_NAME_NEW'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Project Name New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63894092469137400)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Task Number New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63893658375137400)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Expenditure Type New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63893284700137400)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63892883579137399)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63892514285137399)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63892114482137399)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63891707622137399)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63891255933137399)
,p_db_column_name=>'FUTURE1'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63890897221137399)
,p_db_column_name=>'FUTURE2'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63890494288137398)
,p_db_column_name=>'ENTITY_CODE_NEW'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Entity Code New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63890100937137398)
,p_db_column_name=>'COST_CENTER_NEW'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Cost Center New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63889641936137398)
,p_db_column_name=>'BUDGET_GROUB_CODE_NEW'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Budget Groub Code New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63889310156137398)
,p_db_column_name=>'GL_ACCOUNT_NEW'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Gl Account New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63888865579137398)
,p_db_column_name=>'ACTIVITY_NEW'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Activity New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63888437027137398)
,p_db_column_name=>'FUTURE1_NEW'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Future1 New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63888070953137398)
,p_db_column_name=>'FUTURE2_NEW'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Future2 New'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63887679535137397)
,p_db_column_name=>'ALLOCATED_BUDGET'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Allocated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63887275000137397)
,p_db_column_name=>'BUDGET'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63886855133137397)
,p_db_column_name=>'ENCUMBERANCE'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Encumberance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63886457000137397)
,p_db_column_name=>'ACTUAL'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63886067248137397)
,p_db_column_name=>'JAN'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Jan-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63885691092137397)
,p_db_column_name=>'FEB'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Feb-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63885289922137396)
,p_db_column_name=>'MAR'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Mar-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63884870918137396)
,p_db_column_name=>'APR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Apr-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63884449584137396)
,p_db_column_name=>'MAY'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'May-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63884077984137395)
,p_db_column_name=>'JUN'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Jun-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63883670735137395)
,p_db_column_name=>'JUL'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Jul-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63883318798137395)
,p_db_column_name=>'AUG'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Aug-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63882835946137395)
,p_db_column_name=>'SEP'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Sep-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63882442421137395)
,p_db_column_name=>'OCT'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Oct-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63882120559137395)
,p_db_column_name=>'NOV'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Nov-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63881705731137395)
,p_db_column_name=>'DEC'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Dec-&CURRENT_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63881240849137394)
,p_db_column_name=>'LINE_TYPE'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Line Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63880864659137394)
,p_db_column_name=>'TOTAL_CF'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Total Cf'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63880492025137394)
,p_db_column_name=>'NOTE'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63880035208137394)
,p_db_column_name=>'STATUS'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63879709779137394)
,p_db_column_name=>'FINAL_STATUS_ON'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Final Status On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63879238060137394)
,p_db_column_name=>'SOURCE'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63878904166137393)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Request Id'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63878495546137393)
,p_db_column_name=>'REQUEST_LINE_ID'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Request Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63878108799137393)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Initiative Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63877687770137393)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Initiative New Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63877299078137393)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63876928846137393)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63876523000137392)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63876057580137392)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63875676119137392)
,p_db_column_name=>'TOTAL_CF_FORMAT'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Total'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(83951084478128400)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1494087'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:TOTAL_CF_FORMAT:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(230638525538680619)
,p_plug_name=>'Approval History'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P71_REVIEW_STATUS != ''Draft'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(230674750486026424)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(230638525538680619)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'and h.request_id = :P71_SCOPE_ID',
'and h.status != ''Beaten''',
'order by h.STEP_NO ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P71_SCOPE_ID'
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
 p_id=>wwv_flow_api.id(230674852623026425)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>443958885012211057
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64213336507137609)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64212984259137609)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64212586827137609)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64212157962137608)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64211817934137608)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(64238386933166115)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64211411565137608)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64211027755137608)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64210607232137608)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64210164026137607)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64209777099137607)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64209357746137607)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64209031313137607)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64208586511137607)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64208189232137606)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64207805261137606)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(230965785871355883)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1490766'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(64206937144137606)
,p_report_id=>wwv_flow_api.id(230965785871355883)
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
 p_id=>wwv_flow_api.id(230677106804026447)
,p_plug_name=>'Collabouration'
,p_icon_css_classes=>'fa-envelope-edit'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(230677692097026453)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(230677106804026447)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(504258828797604820)
,p_name=>'Comments Report'
,p_parent_plug_id=>wwv_flow_api.id(230677692097026453)
,p_template=>wwv_flow_api.id(99730028608410735)
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
'where ITEM_ID = :P71_DP_ITEM_ID',
'order by CREATION_DATE desc;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P71_DP_ITEM_ID'
,p_query_row_template=>wwv_flow_api.id(99786373050410764)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Communications yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64202573323137603)
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
 p_id=>wwv_flow_api.id(64202212366137603)
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
 p_id=>wwv_flow_api.id(64201790102137602)
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
 p_id=>wwv_flow_api.id(64202959890137603)
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
 p_id=>wwv_flow_api.id(64201363577137602)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64201008466137602)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64200616006137594)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64200193568137594)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64199786554137594)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64199401611137594)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64198936490137594)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64198548518137593)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64198142120137593)
,p_query_column_id=>13
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>13
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(64203397463137603)
,p_query_column_id=>14
,p_column_alias=>'COMMENT_TO'
,p_column_display_sequence=>14
,p_column_heading=>'Comment To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(365879893747201273)
,p_plug_name=>'Audit'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64149042461137563)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(365881635403201291)
,p_button_name=>'PROJECT_OVERVIEW_HELP_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Introduction Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Requirement Overview,&P71_TEMPLATE_ID.,10'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'Y'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64152464131137566)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(229864590351110120)
,p_button_name=>'DCT_REPRESENTATIVES_AND_SUPPORT_HELP_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'DCT Representatives and Support'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:DCT Representatives and Support,&P71_TEMPLATE_ID.,9'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'Y'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64164356973137572)
,p_button_sequence=>230
,p_button_plug_id=>wwv_flow_api.id(365881573579201290)
,p_button_name=>'LOCATION_OF_WORK_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Location of Work Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Location of Work Guidance,&P71_TEMPLATE_ID.,6'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'N'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64164786282137572)
,p_button_sequence=>270
,p_button_plug_id=>wwv_flow_api.id(365881573579201290)
,p_button_name=>'LANGUAGE_OF_WORK_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Language of Work Guidance,&P71_TEMPLATE_ID.,7'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'N'
,p_grid_column=>6
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64163991711137572)
,p_button_sequence=>310
,p_button_plug_id=>wwv_flow_api.id(365881573579201290)
,p_button_name=>'PROVISION_OF_SERVICES_HELP_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Provision of Services Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Provision of Service Guidance,&P71_TEMPLATE_ID.,8'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'Y'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64204056386137604)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(230677692097026453)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Collaborate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_ITEM_ID:&P71_DP_ITEM_ID.'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64189880076137588)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365735955424260088)
,p_button_name=>'PERFORMANCE_MEASUREMENTS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Performance Measurements,7'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64182124913137583)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365738003499260108)
,p_button_name=>'INTELLECTUAL_PROPERTY'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Intellectual Property/Copyrights of Work,12'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64180171326137581)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365738311340260112)
,p_button_name=>'REPORTING_COM_REQ_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Reporting & Communication Requirements,13'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64178321736137580)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365738738830260116)
,p_button_name=>'ADDED_VALUE_OFFERINGS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Added Value Offerings,14'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64176411645137579)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365739134859260120)
,p_button_name=>'ATT_SUPP_DOCS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Attachments and Supporting Documents,15'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64174877889137578)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(494510863517902194)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::P56_SCOPING_ID,P56_PAGE_FROM,P56_SCOPING_APPENDIX:&P71_SCOPE_ID.,28,A'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64166273085137573)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(363828296991926115)
,p_button_name=>'PROJECT_OVERVIEW_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Project Overview Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Project Overview,1'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64150601373137564)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(363828570905926118)
,p_button_name=>'REQUIREMENTS_OVERVIEW_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Requirements Overview,2'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64146389030137561)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365756777857221014)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:52:&SESSION.::&DEBUG.:52:P52_DP_SCOPING_A_ID:&P71_SCOPE_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64136001424137555)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365736390321260092)
,p_button_name=>'SUPPLIER_RESPONSIBILITIES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Supplier Responsibilities,8'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64129761474137551)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365736728243260096)
,p_button_name=>'PROPOSAL_SUBMISSION'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Proposal Submission Requirements,9'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64123142577137548)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365737205545260100)
,p_button_name=>'Security_Requirement_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Security Requirements,10'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64117348870137544)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365737558450260104)
,p_button_name=>'DATA_CAPTURE_REQUIREMENTS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Data Capture Requirements,11'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64111600887137538)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(363828912056926122)
,p_button_name=>'TIMELINES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Timelines,3'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64107013008137536)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365734755588260076)
,p_button_name=>'SUBMISSION_INFORMATION_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Submission Information,4'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64101885467137533)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365735186321260080)
,p_button_name=>'SCOPE_OF_SERVICES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Scope of Services,5'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64099398235137531)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(365735542735260084)
,p_button_name=>'REQUIRED_DELIVERABLES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Required Deliverables,6'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64141024590137558)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(365783579230990479)
,p_button_name=>'Add_O'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.:55:P55_DP_SCOPING_A_ID:&P71_SCOPE_ID.'
,p_button_condition=>':P71_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64189504665137588)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(365735955424260088)
,p_button_name=>'New_KPI'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New KPI'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.::P34_DP_SCOPING_A_ID:&P71_SCOPE_ID.'
,p_button_condition=>':P71_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64135609225137555)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(365736390321260092)
,p_button_name=>'Add_Resp'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:35:P35_DP_SCOPING_A_ID:&P71_SCOPE_ID.'
,p_button_condition=>':P71_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64129336330137551)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(365736728243260096)
,p_button_name=>'Add_Requirement'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add Requirement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:36:P36_DP_SCOPING_A_ID:&P71_SCOPE_ID.'
,p_button_condition=>':P71_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64122779158137548)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(365737205545260100)
,p_button_name=>'New_Security_Requirement'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New Security Requirement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.:37:P37_DP_SCOPING_A_ID:&P71_SCOPE_ID.'
,p_button_condition=>':P71_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64117010397137544)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(365737558450260104)
,p_button_name=>'New_Data_Capture'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New Data Capture'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.:38:P38_DP_SCOPING_A_ID:&P71_SCOPE_ID.'
,p_button_condition=>':P71_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64098988636137531)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(365735542735260084)
,p_button_name=>'New_deliverable'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New Deliverable'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.:33:P33_DP_SCOPING_A_ID:&P71_SCOPE_ID.'
,p_button_condition=>':P71_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(63846874278137379)
,p_branch_name=>'Go To Page 29'
,p_branch_action=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.::P29_SCOPE_ID,P29_TEMPLATE_ID,P29_ITEM_ID:&P65_SCOPE_ID.,&P65_TEMPLATE_ID.,&P65_DP_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64206328241137605)
,p_name=>'P71_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365879893747201273)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64205926822137605)
,p_name=>'P71_CREATION_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(365879893747201273)
,p_prompt=>'Creation Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64205447831137605)
,p_name=>'P71_UPDATED_BY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(365879893747201273)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64205082092137604)
,p_name=>'P71_UPDATED_DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(365879893747201273)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64194064305137591)
,p_name=>'P71_SCOPE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(368083698176017108)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64193688412137591)
,p_name=>'P71_HISTORY_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(368083698176017108)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64193307292137590)
,p_name=>'P71_TEMPLATE_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(368083698176017108)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64192925246137590)
,p_name=>'P71_SCOPE_CODE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(368083698176017108)
,p_prompt=>'Scope Document Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64192508900137590)
,p_name=>'P71_DP_ITEM_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(368083698176017108)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64192106278137590)
,p_name=>'P71_ITEM_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(368083698176017108)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Item Name'
,p_source=>'P71_DP_ITEM_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_ITEM_NAME , item_id',
'from dp_items;'))
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64191714407137590)
,p_name=>'P71_TEMPLATE_NAME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(368083698176017108)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template Name'
,p_source=>'P71_TEMPLATE_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'SCOPING TEMPLATES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_SCOPE_TEMPLATES.TEMPLATE_NAME as TEMPLATE_NAME ,',
'    DP_SCOPE_TEMPLATES.TEMPLATE_ID as TEMPLATE_ID',
' from DP_SCOPE_TEMPLATES DP_SCOPE_TEMPLATES',
' where status = ''A''',
' and sysdate between nvl(start_date , sysdate -10) and nvl(end_date , sysdate +10)'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64191263202137590)
,p_name=>'P71_REVIEW_STATUS'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(368083698176017108)
,p_prompt=>'Review Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64190902247137589)
,p_name=>'P71_APPROVAL_STATUS'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(368083698176017108)
,p_prompt=>'Approval Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64189078894137588)
,p_name=>'P71_PERFOR_MEASUR_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365735955424260088)
,p_prompt=>'PERFORMANCE_MEASUREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64188643242137587)
,p_name=>'P71_PERFORM_MEASUR_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365735955424260088)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64181644573137583)
,p_name=>'P71_INTEL_PROP_COPYRIGHTS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365738003499260108)
,p_prompt=>'INTELLECTUAL_PROPERTY_COPYRIGHTS_OF_WORK_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64181238774137583)
,p_name=>'P71_INTELLECTUAL_PROPERTY_COPYRIGHTS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365738003499260108)
,p_prompt=>'Intellectual Property Copyrights'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  21 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64180865778137582)
,p_name=>'P71_INTELL_PRO_COPYRIGHTSLABEL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(365738003499260108)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64179753318137581)
,p_name=>'P71_REPORT_COMM_REQ_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365738311340260112)
,p_prompt=>'REPORTING_COMMUNICATION_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64179418992137581)
,p_name=>'P71_REPORTING_COMMUNICATION_REQ'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365738311340260112)
,p_prompt=>'Reporting Communication Requirements'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  22 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64179024474137581)
,p_name=>'P71_REPORT_COMM_REQ_LABEL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(365738311340260112)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64177863431137580)
,p_name=>'P71_ADDED_VALUE_OFFERINGS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365738738830260116)
,p_prompt=>'ADDED_VALUE_OFFERINGS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64177482342137580)
,p_name=>'P71_ADDED_VALUE_OFFERINGS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365738738830260116)
,p_prompt=>'Added Value Offerings'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  23 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64177126703137580)
,p_name=>'P71_ADDED_VALUE_OFFERINGS_LAB'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(365738738830260116)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64176022437137579)
,p_name=>'P71_ATT_DOCUMENTS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365739134859260120)
,p_prompt=>'ATTACHMENTS_SUPPORTING_DOCUMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64175595726137579)
,p_name=>'P71_ATTACH_DOC_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365739134859260120)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64165909194137573)
,p_name=>'P71_PROJECT_OVERVIEW_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(363828296991926115)
,p_prompt=>'PROJECT_OVERVIEW_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64165505716137573)
,p_name=>'P71_PROJECT_OVERVIEW_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(363828296991926115)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64163535744137572)
,p_name=>'P71_PROJECT_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_prompt=>'&P71_PROJECT_NAME_LABEL.'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN( ''A'' , :P71_TEMPLATE_ID ,  1 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64163215770137571)
,p_name=>'P71_PROJECT_NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_prompt=>'Project Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P71_PROJECT_NUMBER'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64162811892137571)
,p_name=>'P71_PROJECT_CODE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_prompt=>'Project Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P71_PROJECT_CODE'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64162384397137571)
,p_name=>'P71_PROJECT_NAME_LABEL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P71_TEMPLATE_ID ,  1)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64161957733137571)
,p_name=>'P71_MAIN_CATEGORY_ID'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_prompt=>'Main Category'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM MAIN CATEGORIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 231 ;'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64161562699137571)
,p_name=>'P71_DATE_REQUIRED'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_prompt=>'&P71_DATE_REQUIRED_LABEL.'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  2) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'&P28_DATE_REQUIRED_HELP.'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64161221859137571)
,p_name=>'P71_DATE_REQUIRED_LABEL'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P71_TEMPLATE_ID ,  2 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64160745872137570)
,p_name=>'P71_DATE_REQUIRED_HELP'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P71_TEMPLATE_ID ,  2 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64160391904137570)
,p_name=>'P71_SUB_CATEGORY_ID'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_prompt=>'&P71_SUB_CATEGORY_ID_LABEL.'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM SUB CATEGORIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 233 ;'))
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  4 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'&P28_SUB_CATEGORY_ID_HELP.'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64159992278137570)
,p_name=>'P71_RFP_REF_NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_prompt=>'&P71_RFP_REF_NUMBER_LABEL.'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  5 ) = ''Y'' and :P71_RFP_REF_NUMBER is not null'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>'IS_PBP_EMP'
,p_read_only_when2=>'Y'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'&P28_RFP_REF_NUMBER_HELP.'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64159545595137570)
,p_name=>'P71_CATEGORY_ID'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_prompt=>'&P71_CATEGORY_ID_LABEL.'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM CATEGORY  LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 232 ;'))
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  3) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'&P28_CATEGORY_ID_HELP.'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64159149115137570)
,p_name=>'P71_CATEGORY_ID_LABEL'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P71_TEMPLATE_ID , 3)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64158774866137569)
,p_name=>'P71_CATEGORY_ID_HELP'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P71_TEMPLATE_ID , 3)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64158343248137569)
,p_name=>'P71_SUB_CATEGORY_ID_LABEL'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P71_TEMPLATE_ID , 4 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64158021950137569)
,p_name=>'P71_SUB_CATEGORY_ID_HELP'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P71_TEMPLATE_ID , 4 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64157618934137569)
,p_name=>'P71_TEMPLATE'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
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
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64157159778137569)
,p_name=>'P71_RFP_REF_NUMBER_LABEL'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P71_TEMPLATE_ID ,  5 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64156745000137569)
,p_name=>'P71_RFP_REF_NUMBER_HELP'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P71_TEMPLATE_ID ,  5 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64156414504137568)
,p_name=>'P71_LOCATION_OF_WORK'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_prompt=>'&P71_LOCATION_OF_WORK_LABEL.'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>120
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  6 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_item_comment=>'&P71_LOCATION_OF_WORK_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64156015732137568)
,p_name=>'P71_LOCATION_OF_WORK_LABEL'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P71_TEMPLATE_ID ,  6 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64155604000137568)
,p_name=>'P71_LOCATION_OF_WORK_HELP'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P71_TEMPLATE_ID ,  6 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64155132775137568)
,p_name=>'P71_LANGUAGE_OF_WORK'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_prompt=>'&P71_LANGUAGE_OF_WORK_LABEL.'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LANGUAGE LOV'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  7) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
,p_item_comment=>'&P71_LANGUAGE_OF_WORK_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64154827290137568)
,p_name=>'P71_LANGUAGE_OF_WORK_LABEL'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P71_TEMPLATE_ID , 7 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64154354598137567)
,p_name=>'P71_LANGUAGE_OF_WORK_HELP'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P71_TEMPLATE_ID , 7 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64154013557137567)
,p_name=>'P71_PROVISION_OF_SERVICES'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P71_TEMPLATE_ID ,  8 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'&P71_PROVISION_OF_SERVICES_LABEL.'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN( ''A'' , :P71_TEMPLATE_ID ,  8 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_item_comment=>'&P71_PROVISION_OF_SERVICES_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64153547680137567)
,p_name=>'P71_PROVISION_OF_SERVICES_LABEL'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P71_TEMPLATE_ID ,  8 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64153154694137566)
,p_name=>'P71_PROVISION_OF_SERVICES_HELP'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(365881573579201290)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P71_TEMPLATE_ID ,  8 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
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
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64152115760137565)
,p_name=>'P71_DCT_REPRESENTATIVES_AND_SUPPORT'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(229864590351110120)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P71_TEMPLATE_ID ,  9 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'&P71_DCT_REPRESENTATIVES_AND_SUPPORT_LABEL.'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  9 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_item_comment=>'&P71_DCT_REPRESENTATIVES_AND_SUPPORT_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64151711084137565)
,p_name=>'P71_DCT_REPRESENTATIVES_AND_SUPPORT_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(229864590351110120)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P71_TEMPLATE_ID , 9 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64151321543137565)
,p_name=>'P71_DCT_REPRESENTATIVES_AND_SUPPORT_HELP'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(229864590351110120)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P71_TEMPLATE_ID , 9 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64150185972137564)
,p_name=>'P71_REQUIREMENTS_OVERVIEW_LAB'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(363828570905926118)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64149744171137564)
,p_name=>'P71_REQUIREMENTS_OVERVIEW_HELP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(363828570905926118)
,p_prompt=>'REQUIREMENTS_OVERVIEW_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64148662473137563)
,p_name=>'P71_INTRODUCTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365881635403201291)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P71_TEMPLATE_ID ,  10 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'&P71_INTRODUCTION_LABEL.'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  10 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_item_comment=>'&P71_INTRODUCTION_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64148308694137563)
,p_name=>'P71_INTRODUCTION_HELP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(365881635403201291)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P71_TEMPLATE_ID , 10  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'U'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64147867202137563)
,p_name=>'P71_INTRODUCTION_LABEL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(365881635403201291)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P71_TEMPLATE_ID , 10  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'U'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64147495149137563)
,p_name=>'P71_ABOUT_DCT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(365881635403201291)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P71_TEMPLATE_ID ,  11 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'About DCT'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>10
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  11 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64147058345137562)
,p_name=>'P71_BACKGROUND_AND_SERVICES_REQUIRED'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(365881635403201291)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P71_TEMPLATE_ID ,  12 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Background and Services Required'
,p_display_as=>'NATIVE_TEXTAREA'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  12 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64135227209137554)
,p_name=>'P71_SUPPLIER_RES_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365736390321260092)
,p_prompt=>'SUPPLIER_RESPONSIBILITIES_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64134762336137554)
,p_name=>'P71_SUPPLIER_RESPONS_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365736390321260092)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64128953554137551)
,p_name=>'P71_PROPO_SUBMISSION_REQ_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365736728243260096)
,p_prompt=>'PROPOSAL_SUBMISSION_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64128603376137551)
,p_name=>'P71_PROPOSAL_SUBM_REQ_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365736728243260096)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64122346579137547)
,p_name=>'P71_SECURITY_REQUIREMENTS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365737205545260100)
,p_prompt=>'SECURITY_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64122002035137547)
,p_name=>'P71_SECURITY_REQUIREMENT_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365737205545260100)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64116618388137544)
,p_name=>'P71_DATA_CAPTURE_REQ_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365737558450260104)
,p_prompt=>'DATA_CAPTURE_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64116160858137544)
,p_name=>'P71_DATA_CAPTURE_REQ_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365737558450260104)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64111162947137538)
,p_name=>'P71_TIMELINES_LABEL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(363828912056926122)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64110798727137538)
,p_name=>'P71_TIMELINES_HELP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(363828912056926122)
,p_prompt=>'TIMELINES_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64110087350137537)
,p_name=>'P71_EXPECTED_START_DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365881765155201292)
,p_prompt=>'Expected Contract Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  13 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64109649102137537)
,p_name=>'P71_EXPECTED_END_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(365881765155201292)
,p_prompt=>'Expected Contract End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  14 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64109307746137537)
,p_name=>'P71_TENDER_START_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(365881765155201292)
,p_prompt=>'Expected Tender start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  15 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64108889952137537)
,p_name=>'P71_TENDER_END_DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(365881765155201292)
,p_prompt=>'Expected Tender End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  16 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64108461064137536)
,p_name=>'P71_EXPECTED_CONTRACT_START_DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(365881765155201292)
,p_prompt=>'Expected Contract Start Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64108048914137536)
,p_name=>'P71_EXPECTED_CONTRACT_END_DATE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(365881765155201292)
,p_prompt=>'Expected Contract End Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64107702977137536)
,p_name=>'P71_DURATION_COMMENTS'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(365881765155201292)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P71_TEMPLATE_ID ,  17 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Duration Comments'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  17 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64106586847137535)
,p_name=>'P71_SUBMISSION_INFO_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365734755588260076)
,p_prompt=>'SUBMISSION_INFORMATION_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64106203139137535)
,p_name=>'P71_TECHNICAL_SUBMISSION_ID_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365734755588260076)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P71_TEMPLATE_ID , 18  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64105795018137535)
,p_name=>'P71_TECHNICAL_SUBMISSION_ID_HELP'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(365734755588260076)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P71_TEMPLATE_ID , 18  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64105412240137535)
,p_name=>'P71_TECHNICAL_SUBMISSION_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(365734755588260076)
,p_prompt=>'&P71_TECHNICAL_SUBMISSION_ID_LABEL.'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TECHNICAL SUBMISSION LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 51 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  18 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
,p_item_comment=>'&P71_TECHNICAL_SUBMISSION_ID_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64104972098137535)
,p_name=>'P71_BAFO_NEGOTIATION_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(365734755588260076)
,p_prompt=>'&P71_BAFO_NEGOTIATION_ID_LABEL.'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(782922329120916)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN( ''A'' , :P71_TEMPLATE_ID ,  19) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_inline_help_text=>'&P28_BAFO_NEGOTIATION_ID_HELP.'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64104560053137534)
,p_name=>'P71_SELECTION_CRITERIA'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(365734755588260076)
,p_prompt=>'Selection Criteria'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'MPR PROCUREMENT METHODS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select MPR_PROCUREMENT_METHODS.PROCUREMENT_METHOD_NAME as PROCUREMENT_METHOD_NAME,',
'    MPR_PROCUREMENT_METHODS.ID as ID ',
' from MPR_PROCUREMENT_METHODS MPR_PROCUREMENT_METHODS'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64104195239137534)
,p_name=>'P71_TECH_PCT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(365734755588260076)
,p_prompt=>'Technical'
,p_post_element_text=>'%'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_begin_on_new_line=>'N'
,p_grid_column=>8
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64103732586137534)
,p_name=>'P71_COMM_PCT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(365734755588260076)
,p_prompt=>'Commercial'
,p_post_element_text=>'%'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_begin_on_new_line=>'N'
,p_grid_column=>10
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64103350345137534)
,p_name=>'P71_BAFO_NEGOTIATION_ID_LABEL'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(365734755588260076)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P71_TEMPLATE_ID , 19 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64102985431137534)
,p_name=>'P71_BAFO_NEGOTIATION_ID_HELP'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(365734755588260076)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P71_TEMPLATE_ID , 19 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64102611519137534)
,p_name=>'P71_SUBMISSION_INFO_LABEL'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(365734755588260076)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64101183255137533)
,p_name=>'P71_SCOPE_OF_SERVICES_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(230676630575026442)
,p_use_cache_before_default=>'NO'
,p_prompt=>'SCOPE_OF_SERVICES_HELP'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE (  ''A'' , :P71_TEMPLATE_ID ,  20 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  20 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64100483893137532)
,p_name=>'P71_SCOPE_OF_SERVICES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(230676827385026444)
,p_prompt=>'Scope of Services'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P71_TEMPLATE_ID ,  20 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64100090571137532)
,p_name=>'P71_SCOPE_OF_SERVICES_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(230676827385026444)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64098601299137531)
,p_name=>'P71_REQUIRED_DELIVERABLES_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365735542735260084)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64098156048137531)
,p_name=>'P71_REQUIRED_DELIVERABLE_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(365735542735260084)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64089397253137526)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_85'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(368967582589870519)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 85',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64083205063137521)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_86'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(368969205239870535)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 86',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64076970849137517)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_87'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(368970814070870551)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 87',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64070798735137514)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_89'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(368990985809843133)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 89',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64064647531137510)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_90'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(368992629302843149)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 90',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64058489096137507)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_91'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(369008588577823715)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 91',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64052274876137504)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_92'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(369010260147823731)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 92',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64046115698137496)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_93'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(369011848620823747)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 93',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64039856174137492)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_94'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(369030697044717013)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 94',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64033655011137488)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_96'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(369032281573717029)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 96',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64027486133137484)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_97'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(369033888116717045)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 97',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64021272709137481)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_98'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(369055240429683511)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 98',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64015035881137477)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_99'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(369055487355683514)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 99',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64008876073137474)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_100'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(369058435401683543)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 100',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64002675699137470)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_101'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(369060005491683559)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 101',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63996457175137467)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_16'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365999369392334012)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 16',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63990302140137464)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_17'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365999484047334013)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 17',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63984071333137460)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_18'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365999740096334015)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 18',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63977905306137457)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_19'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(365999892051334017)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 19',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63971655751137452)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_20'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(366000141809334019)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 20',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63965509592137448)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_81'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(368930975217955355)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 81',
'AND template_id = :P71_TEMPLATE_ID;'))
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63959261608137445)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_82'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(368947502765910221)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 82',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63953091941137441)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_83'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(368949143651910237)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 83',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63946915551137438)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_84'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(368950752000910253)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 84',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63940667276137434)
,p_name=>'P71_TEMPLATE_COMPOENET_ID_88'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(368989393626843117)
,p_use_cache_before_default=>'NO'
,p_item_default=>'1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COMPONENT_TEMPLATE_ID ',
'FROM dp_scope_comp_template_details',
'where component_id = 88',
'AND template_id = :P71_TEMPLATE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63914563484137414)
,p_name=>'P71_LINE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63914204734137414)
,p_name=>'P71_BUDGET_ALLOCATION_PLAN_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63913814454137414)
,p_name=>'P71_ACCOUNTING_YEAR'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63913402653137410)
,p_name=>'P71_MULTI_YEAR_YN'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_prompt=>'Multi Year ?'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63913071626137410)
,p_name=>'P71_DISTRIBUTION_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63912638108137410)
,p_name=>'P71_PROJECT_NUMBER_1'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_prompt=>'Project Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63912323599137410)
,p_name=>'P71_ESTIMATED_BUDGET'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Estimated Budget'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(estimated_budget,''99,999,999,999,999.99'')) || '' AED'' bud',
'from dp_items',
'where item_id = :P71_DP_ITEM_ID	'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63911833012137409)
,p_name=>'P71_TASK_NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_prompt=>'Task'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TASK_NUMBER d, TASK_NUMBER r ',
'from task',
'where PROJECT_NUMBER = :P71_PROJECT_NUMBER'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P71_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63911473074137409)
,p_name=>'P71_STATUS'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63911077638137409)
,p_name=>'P71_EXPENDITURE_TYPE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_prompt=>'Expenditure Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXPENDITURE_TYPE d, EXPENDITURE_TYPE r',
'from expenditure',
'where PROJECT_NUMBER =  :P71_PROJECT_NUMBER',
'and TASK_NUMBER = :P71_TASK_NUMBER;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P71_PROJECT_NUMBER,P71_TASK_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63910687994137407)
,p_name=>'P71_NEW_PROJECT_NAME'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_prompt=>'New Project Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when=>'P71_NEW_PROJECT_NAME'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63910232938137407)
,p_name=>'P71_NEW_TASK_NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_prompt=>'New Task'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when=>'P71_NEW_TASK_NUMBER'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63909840682137407)
,p_name=>'P71_NEW_EXPENDITURE_TYPE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_prompt=>'New Expenditure Type'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when=>'P71_NEW_EXPENDITURE_TYPE'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63909507212137407)
,p_name=>'P71_ENTITY_CODE'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63909106537137407)
,p_name=>'P71_ENTITY_CODE_NEW'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63908703647137406)
,p_name=>'P71_COST_CENTER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63908294179137406)
,p_name=>'P71_COST_CENTER_NEW'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63907875751137406)
,p_name=>'P71_BUDGET_GROUB_CODE'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63907515920137406)
,p_name=>'P71_BUDGET_GROUB_CODE_NEW'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63907085393137406)
,p_name=>'P71_GL_ACCOUNT'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63906644511137406)
,p_name=>'P71_GL_ACCOUNT_NEW'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63906262102137405)
,p_name=>'P71_ACTIVITY'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63905856035137405)
,p_name=>'P71_ACTIVITY_NEW'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63905530515137405)
,p_name=>'P71_FUTURE1'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63905116036137405)
,p_name=>'P71_FUTURE1_NEW'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63904696069137405)
,p_name=>'P71_FUTURE2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63904318090137405)
,p_name=>'P71_FUTURE2_NEW'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63903911559137404)
,p_name=>'P71_ALLOCATED_BUDGET'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63903530598137404)
,p_name=>'P71_LINE_TYPE'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63903110861137404)
,p_name=>'P71_NOTE'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_prompt=>'Note'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>70
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63902688286137404)
,p_name=>'P71_SOURCE'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63902325502137404)
,p_name=>'P71_REQUEST_ID'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63901836520137404)
,p_name=>'P71_INITIATIVE_ID'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63901433009137403)
,p_name=>'P71_INITIATIVE_NEW_NAME'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63901041281137403)
,p_name=>'P71_SUB_CATEGORY_ID_1'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63900705630137403)
,p_name=>'P71_TEMPLATE_ID_1'
,p_item_sequence=>370
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63900284683137403)
,p_name=>'P71_ITEM_ID'
,p_item_sequence=>380
,p_item_plug_id=>wwv_flow_api.id(366059015253594514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63899606545137402)
,p_name=>'P71_CREATED_BY_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(230220878917786047)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63899151253137402)
,p_name=>'P71_CREATED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(230220878917786047)
,p_prompt=>'Created ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63898806015137402)
,p_name=>'P71_UPDATED_BY_1'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(230220878917786047)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63898359958137402)
,p_name=>'P71_UPDATED_ON'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(230220878917786047)
,p_prompt=>'Updated ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(63871569158137389)
,p_validation_name=>'Validate Evaluation Criteria %'
,p_validation_sequence=>10
,p_validation=>':P71_TECH_PCT + :P71_COMM_PCT = 100'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Total Commercial% and Technical% must be 100. '
,p_always_execute=>'Y'
,p_associated_item=>wwv_flow_api.id(64103732586137534)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63864112310137386)
,p_name=>'Deliverable Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64098988636137531)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63863547969137385)
,p_event_id=>wwv_flow_api.id(63864112310137386)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365785180574990495)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63863218290137385)
,p_name=>'Deliverable Close DA2'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(365785180574990495)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63862683010137385)
,p_event_id=>wwv_flow_api.id(63863218290137385)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365785180574990495)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63862292901137385)
,p_name=>'Performance Measurements Closing DA2'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(365786350140990507)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63861829825137385)
,p_event_id=>wwv_flow_api.id(63862292901137385)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365786350140990507)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63861344625137384)
,p_name=>'Performance Measurements Closing DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64189504665137588)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63860909736137384)
,p_event_id=>wwv_flow_api.id(63861344625137384)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365786350140990507)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63860457265137384)
,p_name=>'DP_SCOPING_A_SUPPLIER_RESP Dialog Close DA'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64135609225137555)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63859990551137384)
,p_event_id=>wwv_flow_api.id(63860457265137384)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365787646946990520)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63859562844137384)
,p_name=>'DP_SCOPING_A_SUPPLIER_RESP Dialog Close DA2'
,p_event_sequence=>60
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(365787646946990520)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63859045198137384)
,p_event_id=>wwv_flow_api.id(63859562844137384)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365787646946990520)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63858649014137384)
,p_name=>'Expand'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64135609225137555)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63858213584137383)
,p_event_id=>wwv_flow_api.id(63858649014137384)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365736390321260092)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63857744121137383)
,p_name=>'Close DA'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64129336330137551)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63857260535137383)
,p_event_id=>wwv_flow_api.id(63857744121137383)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365834668436091782)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63856908785137383)
,p_name=>'Open Dialog'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64129336330137551)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63856415904137383)
,p_event_id=>wwv_flow_api.id(63856908785137383)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365736728243260096)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63856017892137383)
,p_name=>'Close Dialog2'
,p_event_sequence=>100
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(365834668436091782)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63855494035137382)
,p_event_id=>wwv_flow_api.id(63856017892137383)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365834668436091782)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63855063057137382)
,p_name=>'DA Close3'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64122779158137548)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63854548155137382)
,p_event_id=>wwv_flow_api.id(63855063057137382)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365835999845091795)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63854167454137382)
,p_name=>'Open3'
,p_event_sequence=>120
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64122779158137548)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63853683371137382)
,p_event_id=>wwv_flow_api.id(63854167454137382)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365737205545260100)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63853324145137382)
,p_name=>'DA Close3A'
,p_event_sequence=>130
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(365835999845091795)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63852739910137382)
,p_event_id=>wwv_flow_api.id(63853324145137382)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365835999845091795)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63852366584137381)
,p_name=>'Dialog Close4'
,p_event_sequence=>140
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64117010397137544)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63851930675137381)
,p_event_id=>wwv_flow_api.id(63852366584137381)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365837088095091806)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63851454781137381)
,p_name=>'Open4'
,p_event_sequence=>150
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64117010397137544)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63850971543137381)
,p_event_id=>wwv_flow_api.id(63851454781137381)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365737558450260104)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63850607401137381)
,p_name=>'Dialog Close4A'
,p_event_sequence=>160
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(365837088095091806)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63850034525137381)
,p_event_id=>wwv_flow_api.id(63850607401137381)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365837088095091806)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63849634286137380)
,p_name=>'Add DA'
,p_event_sequence=>170
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64146389030137561)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63849139205137380)
,p_event_id=>wwv_flow_api.id(63849634286137380)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365756839658221015)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63848740409137380)
,p_name=>'Changes Refresh DA'
,p_event_sequence=>180
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(365756839658221015)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63848244637137380)
,p_event_id=>wwv_flow_api.id(63848740409137380)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365756839658221015)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63847856746137380)
,p_name=>'Add_O DA'
,p_event_sequence=>190
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64141024590137558)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63847404185137380)
,p_event_id=>wwv_flow_api.id(63847856746137380)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365783730165990481)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63870059239137388)
,p_name=>'Add_O DA2'
,p_event_sequence=>200
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(365783730165990481)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63869625123137388)
,p_event_id=>wwv_flow_api.id(63870059239137388)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(365783730165990481)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63867353781137387)
,p_name=>'Selection Criteria DA'
,p_event_sequence=>220
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P71_SELECTION_CRITERIA'
,p_condition_element=>'P71_SELECTION_CRITERIA'
,p_triggering_condition_type=>'IN_LIST'
,p_triggering_expression=>'2'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63866845677137387)
,p_event_id=>wwv_flow_api.id(63867353781137387)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P71_TECH_PCT,P71_COMM_PCT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63865867907137386)
,p_event_id=>wwv_flow_api.id(63867353781137387)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P71_TECH_PCT,P71_COMM_PCT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63866402154137387)
,p_event_id=>wwv_flow_api.id(63867353781137387)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P71_TECH_PCT,P71_COMM_PCT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63865492935137386)
,p_name=>'Check PCT DA'
,p_event_sequence=>230
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P71_TECH_PCT,P71_COMM_PCT'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'Number(apex.item("P71_TECH_PCT").getValue()) + Number(apex.item("P71_COMM_PCT").getValue()) != 100  '
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63865007959137386)
,p_event_id=>wwv_flow_api.id(63865492935137386)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Total Commercial% and Technical% must be 100. '
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63864484779137386)
,p_event_id=>wwv_flow_api.id(63865492935137386)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P71_COMM_PCT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63869136321137388)
,p_name=>'Close Comment DA'
,p_event_sequence=>240
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64204056386137604)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63868688740137387)
,p_event_id=>wwv_flow_api.id(63869136321137388)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(504258828797604820)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63868321373137387)
,p_name=>'Close Comment2 DA'
,p_event_sequence=>250
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(504258828797604820)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
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
 p_id=>wwv_flow_api.id(63867779969137387)
,p_event_id=>wwv_flow_api.id(63868321373137387)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(504258828797604820)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(63870925578137389)
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
'    :P71_scope_id,',
'    :P71_scope_code,',
'    :P71_dp_item_id,',
'    :P71_project_name,',
'    :P71_project_code,',
'    :P71_project_number,',
'    :P71_provision_of_services,',
'    :P71_date_required,',
'    :P71_main_category_id,',
'    :P71_category_id,',
'    :P71_sub_category_id,',
'    :P71_rfp_ref_number,',
'    :P71_location_of_work,',
'    :P71_language_of_work,',
'    :P71_dct_representatives_and_support,',
'    :P71_introduction,',
'    :P71_about_dct,',
'    :P71_background_and_services_required,',
'    :P71_expected_start_date,',
'    :P71_expected_end_date,',
'    :P71_duration_comments,',
'    :P71_tender_start_date,',
'    :P71_tender_end_date,',
'    :P71_technical_submission_id,',
'    :P71_bafo_negotiation_id,',
'    :P71_SELECTION_CRITERIA,',
'    :P71_scope_of_services,',
'    :P71_intellectual_property_copyrights,',
'    :P71_reporting_communication_req,',
'    :P71_added_value_offerings,',
'    :P71_created_by,',
'    :P71_updated_by,',
'    :P71_creation_date,',
'    :P71_updated_date,',
'    :P71_APPROVAL_STATUS,',
'    :P71_REVIEW_STATUS,',
'    :P71_TEMPLATE,',
'    :P71_TEMPLATE_ID,',
'    :P71_EXPECTED_CONTRACT_START_DATE,',
'    :P71_EXPECTED_CONTRACT_END_DATE,',
'    :P71_COMM_PCT,',
'    :P71_TECH_PCT',
'FROM',
'    dp_scoping_a',
'WHERE scope_id = :P71_scope_id  ;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(63871321997137389)
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
'    :P71_LINE_ID,',
'    :P71_BUDGET_ALLOCATION_PLAN_ID,',
'    :P71_ACCOUNTING_YEAR,',
'    :P71_MULTI_YEAR_YN,',
'    :P71_DISTRIBUTION_DATE,',
'    :P71_PROJECT_NUMBER_1,',
'    :P71_TASK_NUMBER,',
'    :P71_EXPENDITURE_TYPE,',
'    :P71_NEW_PROJECT_NAME,',
'    :P71_NEW_TASK_NUMBER,',
'    :P71_NEW_EXPENDITURE_TYPE,',
'    :P71_ENTITY_CODE,',
'    :P71_COST_CENTER,',
'    :P71_BUDGET_GROUB_CODE,',
'    :P71_gl_account,',
'    :P71_activity,',
'    :P71_future1,',
'    :P71_future2,',
'    :P71_entity_code_new,',
'    :P71_cost_center_new,',
'    :P71_budget_groub_code_new,',
'    :P71_gl_account_new,',
'    :P71_activity_new,',
'    :P71_future1_new,',
'    :P71_future2_new,',
'    :P71_ALLOCATED_BUDGET,',
'    :P71_LINE_TYPE,',
'    :P71_NOTE,',
'    :P71_STATUS,',
'    :P71_SOURCE,',
'    :P71_REQUEST_ID,',
'    :P71_INITIATIVE_ID,',
'    :P71_INITIATIVE_NEW_NAME,',
'    :P71_CREATED_BY,',
'    :P71_created_on,',
'    :P71_updated_by,',
'    :P71_updated_on',
'FROM    cashflow_lines',
'where request_id = :P71_SCOPE_ID;   '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(63870487370137388)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Scoping Appendix A Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UPDATE dp_scoping_a',
'SET ',
'    provision_of_services = :P71_provision_of_services,',
'    date_required = to_date(:P71_date_required,''dd-Mon-YYYY''),',
' --   rfp_ref_number = :P71_rfp_ref_number,',
'    location_of_work = :P71_location_of_work,',
'    language_of_work = :P71_language_of_work,',
'    dct_representatives_and_support = :P71_dct_representatives_and_support ,',
'    introduction = :P71_introduction,',
'    about_dct = :P71_about_dct ,',
'    background_and_services_required = :P71_background_and_services_required ,',
'    expected_start_date = to_date(:P71_expected_start_date,''dd-Mon-YYYY''),',
'    expected_end_date = to_date(:P71_expected_end_date,''dd-Mon-YYYY''),',
'    duration_comments = :P71_duration_comments ,',
'    tender_start_date = to_date(:P71_tender_start_date,''dd-Mon-YYYY''),',
'    tender_end_date = to_date(:P71_tender_end_date,''dd-Mon-YYYY''),',
'    technical_submission_id = :P71_technical_submission_id ,',
'    bafo_negotiation_id = :P71_bafo_negotiation_id ,',
'    SELECTION_CRITERIA = :P71_SELECTION_CRITERIA,',
'    scope_of_services = :P71_scope_of_services ,',
'    intellectual_property_copyrights = :P71_intellectual_property_copyrights ,',
'    reporting_communication_requirements = :P71_REPORTING_COMMUNICATION_REQ ,',
'    added_value_offerings = :P71_added_value_offerings,',
'    EXPECTED_CONTRACT_START_DATE = :P71_EXPECTED_CONTRACT_START_DATE,',
'    EXPECTED_CONTRACT_END_DATE = :P71_EXPECTED_CONTRACT_END_DATE,',
'    COMM_PCT = :P71_COMM_PCT,',
'    TECH_PCT = :P71_TECH_PCT',
'where  scope_id = :P71_scope_id;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
