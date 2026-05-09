prompt --application/pages/page_00032
begin
--   Manifest
--     PAGE: 00032
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>32
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'Pending GRN Documents'
,p_alias=>'PENDING-GRN-DOCUMENTS'
,p_step_title=>'Pending GRN Documents'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220602055715'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2120731622372964)
,p_plug_name=>'Documents'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19192662303383345)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    "ID",',
'    "ROW_VERSION_NUMBER",',
'    "FILENAME",',
'    "FILE_MIMETYPE",',
'    "FILE_CHARSET",',
'    sys.dbms_lob.getlength("FILE_BLOB") "FILE_BLOB",',
'    "FILE_COMMENTS",',
'    "TAGS",',
'    "CREATED",',
'    "CREATED_BY_PERSON_ID",',
'    "UPDATED",',
'    "UPDATED_BY_PERSON_ID",',
'    type,',
'    sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'FROM',
'    "SCM_PENDING_GRN_DOCUMENTS"'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Documents'
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
 p_id=>wwv_flow_api.id(2120331704372964)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.:RP:P33_ID:\#ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>50191989794349626
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2120290264372964)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2119849779372963)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2119435497372963)
,p_db_column_name=>'FILENAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Filename'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2119041522372963)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2118690700372963)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2118264708372963)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'File Blob'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2117822263372962)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2117433000372962)
,p_db_column_name=>'TAGS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2117053908372962)
,p_db_column_name=>'CREATED'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2116644398372962)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Created By Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2116232311372962)
,p_db_column_name=>'UPDATED'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2115880402372962)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Updated By Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11974129189745565)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>22
,p_column_identifier=>'M'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11974051859745564)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>32
,p_column_identifier=>'N'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:SCM_PENDING_GRN_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54974502110006354)
,p_db_column_name=>'TYPE'
,p_display_order=>42
,p_column_identifier=>'O'
,p_column_label=>'Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(2106056488346331)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'502063'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:ROW_VERSION_NUMBER:FILENAME:FILE_MIMEFILE_CHARSET:FILE_BLOB:FILE_COMMENTS:TAGS:CREATED:CREATED_BY_PERSON_ID:UPDATED:UPDATED_BY_PERSON_ID:FILE_SIZE:DOWNLOAD:TYPE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2115279895372961)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19203962458383352)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(19140599913383303)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(19258056279383396)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2114027108372961)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(2120731622372964)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(19256621748383394)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Attach'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.:33:P33_TYPE:&P32_TYPE.'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11973974678745563)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(2120731622372964)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(19256621748383394)
,p_button_image_alt=>'Back'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54974329878006352)
,p_name=>'P32_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(2115279895372961)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
