prompt --application/pages/page_00119
begin
--   Manifest
--     PAGE: 00119
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
 p_id=>119
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Manage Cost Centers'
,p_alias=>'MANAGE-COST-CENTERS'
,p_step_title=>'Manage Cost Centers'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231024205326'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(15947784671522529)
,p_plug_name=>'Manage Cost Centers Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CC_CODE,',
'       CC_NAME_EN,',
'       CC_NAME_AR,',
'       STATUS,',
'       SECTOR_ORG_ID,',
'       BUSINESS_ACTIVITY_ID,',
'       START_DATE,',
'       END_DATE,',
'       CREATED_BY,',
'       CREATED_DATE,',
'       UPDATED_DATE,',
'       UPDATED_BY,',
'       DCT_ENTITE,',
'       MAIN_CATEGORY,',
'       SUB_CATEGORY,',
'       ACCOUNT_CODE,',
'       ACTIVITY_CODE,',
'       FUTURE1,',
'       FUTURE2,',
'       BUDGET_GROUP,',
'       ou_code',
'  from DCT_COST_CENTERS'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Manage Cost Centers Report'
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
 p_id=>wwv_flow_api.id(15947404835522529)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:120:&SESSION.::&DEBUG.:RP:P120_CC_CODE:\#CC_CODE#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>197336627553662103
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15947248062522528)
,p_db_column_name=>'CC_CODE'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Cost Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15946892224522524)
,p_db_column_name=>'CC_NAME_EN'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Cost Center Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15946445287522523)
,p_db_column_name=>'CC_NAME_AR'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Cc Name Ar'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15946060906522523)
,p_db_column_name=>'STATUS'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15945718923522523)
,p_db_column_name=>'SECTOR_ORG_ID'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15945301170522523)
,p_db_column_name=>'BUSINESS_ACTIVITY_ID'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Business Activity'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71071274690402025)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15944888795522522)
,p_db_column_name=>'START_DATE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15944467025522522)
,p_db_column_name=>'END_DATE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15944062599522522)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15943655469522522)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15943315959522522)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15942891425522521)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15942456125522521)
,p_db_column_name=>'DCT_ENTITE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Entity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15942117206522521)
,p_db_column_name=>'MAIN_CATEGORY'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Main Category'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(64239984803166116)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15941677086522521)
,p_db_column_name=>'SUB_CATEGORY'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Sub Category'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(64239007387166116)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15941261928522521)
,p_db_column_name=>'ACCOUNT_CODE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Account Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15940931935522520)
,p_db_column_name=>'ACTIVITY_CODE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Activity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15940495789522518)
,p_db_column_name=>'FUTURE1'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15940131426522518)
,p_db_column_name=>'FUTURE2'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(15939670730522518)
,p_db_column_name=>'BUDGET_GROUP'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Budget Group'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16966609299689021)
,p_db_column_name=>'OU_CODE'
,p_display_order=>30
,p_column_identifier=>'U'
,p_column_label=>'Operating Unit'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(15929740847495018)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1973543'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CC_CODE:CC_NAME_EN:SECTOR_ORG_ID:OU_CODE:STATUS:'
,p_sort_column_1=>'CC_CODE'
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
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(15937476209522512)
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
 p_id=>wwv_flow_api.id(15936304148522511)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(15937476209522512)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:120:&SESSION.::&DEBUG.:120'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(15938613914522514)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(15947784671522529)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(15938036157522513)
,p_event_id=>wwv_flow_api.id(15938613914522514)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(15947784671522529)
);
wwv_flow_api.component_end;
end;
/
