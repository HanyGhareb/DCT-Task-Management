prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>5
,p_user_interface_id=>wwv_flow_api.id(36116058293523070)
,p_name=>'Service Providers Report'
,p_alias=>'SERVICE-PROVIDERS-REPORT'
,p_step_title=>'Service Providers Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230710065321'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36555421805372100)
,p_plug_name=>'Service Providers Report '
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(36029582862523142)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    "SERVICE_PROVIDER_ID",',
'    "FIRST_NAME",',
'    "SECOND_NAME",',
'    "LAST_NAME",',
'    "FIRST_NAME_AR",',
'    "SECOND_NAME_AR",',
'    "LAST_NAME_AR",',
'    "FULL_NAME_EN",',
'    "FULL_NAME_AR",',
'    "TITLE",',
'    "NATIONAL_IDENTIFIER",',
'    "PASSPORT_NUM",',
'    "EMAIL",',
'    "MOBILE_NO",',
'    "NATIONALITY_CODE",',
'    "ACTIVITIES",',
'    "OTHER_ACTIVITY_NAME",',
'    "EVENT_NAME",',
'    "ORG_ID",',
'    "DEPARTMENT_ID",',
'    "PO_BOX",',
'    "ADDRESS",',
'    "CITY",',
'    "EMIRATE",',
'    "COUNTRY",',
'    "PHOTO_FILENAME",',
'    "PHOTO_MIMETYPE",',
'    "PHOTO_CHARSET",',
'    sys.dbms_lob.getlength("PHOTO_BLOB") "PHOTO_BLOB",',
'    "PHOTO_LAST_UPDATE",',
'    "STATUS",',
'    "SEX",',
'    "PERSON_TYPE_ID",',
'    "USER_NAME",',
'    "PASSWORD",',
'    "CHANGE_PASSWORD",',
'    "COST_CENTER",',
'    "CREATED_BY",',
'    "CREATED_ON",',
'    "UPDATED_BY",',
'    "UPDATED_ON",',
'    "SOURCE",',
'    "REGISTRATION_REQ_ID",',
'    "PERSON_CATEGORY_ID",',
'    vendor_number,',
'    vendor_site_code',
'FROM',
'    "SERVICE_PROVIDERS"'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Service Providers Report '
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
 p_id=>wwv_flow_api.id(36555841266372100)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:RP:P6_SERVICE_PROVIDER_ID:\#SERVICE_PROVIDER_ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>36555841266372100
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36555993290372098)
,p_db_column_name=>'SERVICE_PROVIDER_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Service Provider Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36556396858372097)
,p_db_column_name=>'FIRST_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'First Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36556701619372097)
,p_db_column_name=>'SECOND_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Second Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36557182782372097)
,p_db_column_name=>'LAST_NAME'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Last Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36557537058372097)
,p_db_column_name=>'FIRST_NAME_AR'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'First Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36557964021372096)
,p_db_column_name=>'SECOND_NAME_AR'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Second Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36558327585372096)
,p_db_column_name=>'LAST_NAME_AR'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Last Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36558727167372096)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Full Name '
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36559192503372095)
,p_db_column_name=>'FULL_NAME_AR'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Full Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36559514573372095)
,p_db_column_name=>'TITLE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36559913068372095)
,p_db_column_name=>'NATIONAL_IDENTIFIER'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'National ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36560311163372094)
,p_db_column_name=>'PASSPORT_NUM'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Passport Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36560725899372094)
,p_db_column_name=>'EMAIL'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36561141405372094)
,p_db_column_name=>'MOBILE_NO'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Mobile No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36561563155372094)
,p_db_column_name=>'NATIONALITY_CODE'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Nationality'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36652580900297897)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36561959064372093)
,p_db_column_name=>'ACTIVITIES'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Activities'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36562315154372093)
,p_db_column_name=>'OTHER_ACTIVITY_NAME'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Other Activity Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36562782340372092)
,p_db_column_name=>'EVENT_NAME'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Event Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36563114846372092)
,p_db_column_name=>'ORG_ID'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Organization'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(36637578186702701)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36563534259372092)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36345980280462574)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36563954561372092)
,p_db_column_name=>'PO_BOX'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'PO Box'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36564321776372091)
,p_db_column_name=>'ADDRESS'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Address'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36564710977372091)
,p_db_column_name=>'CITY'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'City'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36565193765372091)
,p_db_column_name=>'EMIRATE'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Emirate'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36565566951372090)
,p_db_column_name=>'COUNTRY'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Country'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36565904149372090)
,p_db_column_name=>'PHOTO_FILENAME'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Photo Filename'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36566376482372090)
,p_db_column_name=>'PHOTO_MIMETYPE'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Photo Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36566758596372089)
,p_db_column_name=>'PHOTO_CHARSET'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Photo Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36567184451372089)
,p_db_column_name=>'PHOTO_BLOB'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Photo Blob'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DOWNLOAD:SERVICE_PROVIDERS:PHOTO_BLOB:SERVICE_PROVIDER_ID'
,p_tz_dependent=>'N'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36567568257372089)
,p_db_column_name=>'PHOTO_LAST_UPDATE'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Photo Last Update'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36567959240372088)
,p_db_column_name=>'STATUS'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36332269880816961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36568383709372088)
,p_db_column_name=>'SEX'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Gender'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36649721030297905)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36568759898372088)
,p_db_column_name=>'PERSON_TYPE_ID'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Person Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(36633786100168451)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36569182863372087)
,p_db_column_name=>'USER_NAME'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36569500200372087)
,p_db_column_name=>'PASSWORD'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Password'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36570348361372086)
,p_db_column_name=>'CHANGE_PASSWORD'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Change Password'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36570793396372086)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36571178184372086)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36571569585372086)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>40
,p_column_identifier=>'AN'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36571936856372085)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36572351413372085)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>42
,p_column_identifier=>'AP'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36572771703372084)
,p_db_column_name=>'SOURCE'
,p_display_order=>43
,p_column_identifier=>'AQ'
,p_column_label=>'Source'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36573148283372084)
,p_db_column_name=>'REGISTRATION_REQ_ID'
,p_display_order=>44
,p_column_identifier=>'AR'
,p_column_label=>'Registration Req Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(36573556033372084)
,p_db_column_name=>'PERSON_CATEGORY_ID'
,p_display_order=>45
,p_column_identifier=>'AS'
,p_column_label=>'Contract Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36635194858118340)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37128951120203038)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>55
,p_column_identifier=>'AT'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37129056104203039)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>65
,p_column_identifier=>'AU'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(36576612362367358)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'365767'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FULL_NAME_EN:EMAIL:USER_NAME:COST_CENTER:PERSON_CATEGORY_ID:STATUS::VENDOR_NUMBER:VENDOR_SITE_CODE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36574848978372079)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(36040859506523136)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(35977418184523185)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(36094925762523096)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(179774503445432429)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(36574848978372079)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36576074178372077)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(36574848978372079)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Service Provider'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_SOURCE:Manual'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
