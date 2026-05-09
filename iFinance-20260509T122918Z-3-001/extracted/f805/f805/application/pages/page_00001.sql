prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(36116058293523070)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'Freelancers-Test'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231001140348'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(179774621659432430)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(36040859506523136)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(35977418184523185)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(36094925762523096)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181244206643796110)
,p_plug_name=>'All Freelancers Requests'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(36031481492523141)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(181244309139796111)
,p_plug_name=>'All Freelancers Requests Report'
,p_parent_plug_id=>wwv_flow_api.id(181244206643796110)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(36029582862523142)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_NUMBER,',
'       NEW_FREELANCER_YN,',
'       FIRST_NAME,',
'       SECOND_NAME,',
'       THIRD_NAME,',
'       LAST_NAME,',
'       FULL_NAME,',
'       LICENSE_AVAILABLE_YN,',
'       LICENSE_EXEMPTION_YN,',
'       CONTRACT_CLASS,',
'       END_USER_ID,',
'       COST_CENTER,',
'       SECTOR_ID,',
'       CONVERSION_ID,',
'       LOCATION_ID,',
'       LINE_MAANAGER_ID,',
'       PAYMENT_TYPE_ID,',
'       PROJECT_DESCRIPTION,',
'       CONTRACT_DURATION_ID,',
'       SECURITY_CLEARANCE_REQUIRED_YN,',
'       IT_REQUIRED_YN,',
'       ACCESS_CARD_REQUIRED_YN,',
'       PASSPORT_NUM,',
'       EMAIL,',
'       MOBILE_NO,',
'       NATIONALITY,',
'       ACTIVITIES,',
'       OTHER_ACTIVITY,',
'       PO_BOX,',
'       ADDRESS,',
'       CITY,',
'       EMIRATE,',
'       COUNTRY,',
'       FIRST_DEAL_WITH_DCT,',
'       NOTES,',
'       PHOTO_FILENAME,',
'       PHOTO_MIMETYPE,',
'       PHOTO_CHARSET,',
'       PHOTO_BLOB,',
'       PHOTO_LAST_UPDATE,',
'       FL_YEAR,',
'       COUNT_YEAR,',
'       STATUS,',
'       SUBMITTED_ON,',
'       SUBMITTED_BY,',
'       FINAL_APPROVED_ON,',
'       FINAL_APPROVED_BY,',
'       REJECTED_ON,',
'       REJECTED_BY,',
'       SECURITY_CLEARANCE_STATUS,',
'       SECURITY_CLEARANCE_SUBMITTED_ON,',
'       SECURITY_CLEARANCE_SUBMITTED_BY,',
'       SECURITY_CLEARANCE_FINAL_APPROVED_ON,',
'       SECURITY_CLEARANCE_FINAL_APPROVED_BY,',
'       SECURITY_CLEARANCE_REJECTED_ON,',
'       SECURITY_CLEARANCE_REJECTED_BY,',
'       SERVICE_AGREEMENT_STATUS,',
'       SERVICE_AGREEMENT_SUBMITTED_ON,',
'       SERVICE_AGREEMENT_SUBMITTED_BY,',
'       SERVICE_AGREEMENT_FINAL_APPROVED_ON,',
'       SERVICE_AGREEMENT_FINAL_APPROVED_BY,',
'       SERVICE_AGREEMENT_REJECTED_ON,',
'       SERVICE_AGREEMENT_REJECTED_BY,',
'       CANCEL_ON,',
'       CANCELLED_BY,',
'       CANCEL_REASON,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       TITLE,',
'       SEX,',
'       PERSON_TYPE_ID,',
'       PERSON_CATEGORY_ID',
'  from FREELANCER_REQUESTS'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'All Freelancers Requests Report'
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
 p_id=>wwv_flow_api.id(181244464162796112)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:30:P30_FREELANCER_REQUEST_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>181244464162796112
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181244513826796113)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181244680499796114)
,p_db_column_name=>'REQUEST_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181244727591796115)
,p_db_column_name=>'NEW_FREELANCER_YN'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'New Freelancer ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36335922833816959)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181244817560796116)
,p_db_column_name=>'FIRST_NAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'First Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181244936425796117)
,p_db_column_name=>'SECOND_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Second Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181245062934796118)
,p_db_column_name=>'THIRD_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Third Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181245185928796119)
,p_db_column_name=>'LAST_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Last Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181245217228796120)
,p_db_column_name=>'FULL_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Full Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181245356455796121)
,p_db_column_name=>'LICENSE_AVAILABLE_YN'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'License Available ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36335922833816959)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181245487598796122)
,p_db_column_name=>'LICENSE_EXEMPTION_YN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'License Exemption ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36335922833816959)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181245582789796123)
,p_db_column_name=>'CONTRACT_CLASS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Contract Class'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181245779455796125)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181245881210796126)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(181704408353707985)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181245954979796127)
,p_db_column_name=>'CONVERSION_ID'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Conversion'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(179712456188247826)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181246040901796128)
,p_db_column_name=>'LOCATION_ID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Location'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(179712617707272318)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181246124522796129)
,p_db_column_name=>'LINE_MAANAGER_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Line Manager'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181246217863796130)
,p_db_column_name=>'PAYMENT_TYPE_ID'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Payment Type'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181246332615796131)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181246496846796132)
,p_db_column_name=>'CONTRACT_DURATION_ID'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Contract Duration'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(179786492184534593)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181246537508796133)
,p_db_column_name=>'SECURITY_CLEARANCE_REQUIRED_YN'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Security Clearance Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36335922833816959)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181246675408796134)
,p_db_column_name=>'IT_REQUIRED_YN'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'IT Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36335922833816959)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181246705191796135)
,p_db_column_name=>'ACCESS_CARD_REQUIRED_YN'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Access Card Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36335922833816959)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181246857555796136)
,p_db_column_name=>'PASSPORT_NUM'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Passport Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181246970206796137)
,p_db_column_name=>'EMAIL'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181247096631796138)
,p_db_column_name=>'MOBILE_NO'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Mobile No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181247147407796139)
,p_db_column_name=>'NATIONALITY'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Nationality'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36652580900297897)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181247292845796140)
,p_db_column_name=>'ACTIVITIES'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Activities'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181247307578796141)
,p_db_column_name=>'OTHER_ACTIVITY'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Other Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181247494451796142)
,p_db_column_name=>'PO_BOX'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'PO Box'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181247578983796143)
,p_db_column_name=>'ADDRESS'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Address'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181247632556796144)
,p_db_column_name=>'CITY'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'City'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181247775470796145)
,p_db_column_name=>'EMIRATE'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Emirate'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181247854045796146)
,p_db_column_name=>'COUNTRY'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Country'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181247911307796147)
,p_db_column_name=>'FIRST_DEAL_WITH_DCT'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'First Deal With DCT ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(36335922833816959)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181248003890796148)
,p_db_column_name=>'NOTES'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181248166271796149)
,p_db_column_name=>'PHOTO_FILENAME'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Photo Filename'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181248263684796150)
,p_db_column_name=>'PHOTO_MIMETYPE'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Photo Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181668933326656201)
,p_db_column_name=>'PHOTO_CHARSET'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Photo Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181669068330656202)
,p_db_column_name=>'PHOTO_BLOB'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Photo Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181669101350656203)
,p_db_column_name=>'PHOTO_LAST_UPDATE'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Photo Last Update'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181669253070656204)
,p_db_column_name=>'FL_YEAR'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Fl Year'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181669347255656205)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181669409713656206)
,p_db_column_name=>'STATUS'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181669523592656207)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181669689701656208)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181669721451656209)
,p_db_column_name=>'FINAL_APPROVED_ON'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Final Approved On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181669872485656210)
,p_db_column_name=>'FINAL_APPROVED_BY'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Final Approved By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181669955862656211)
,p_db_column_name=>'REJECTED_ON'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Rejected On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181670074827656212)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181670139605656213)
,p_db_column_name=>'SECURITY_CLEARANCE_STATUS'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Security Clearance Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181670272793656214)
,p_db_column_name=>'SECURITY_CLEARANCE_SUBMITTED_ON'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Security Clearance Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181670315535656215)
,p_db_column_name=>'SECURITY_CLEARANCE_SUBMITTED_BY'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Security Clearance Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181670465055656216)
,p_db_column_name=>'SECURITY_CLEARANCE_FINAL_APPROVED_ON'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Security Clearance Final Approved On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181670527415656217)
,p_db_column_name=>'SECURITY_CLEARANCE_FINAL_APPROVED_BY'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Security Clearance Final Approved By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181670678530656218)
,p_db_column_name=>'SECURITY_CLEARANCE_REJECTED_ON'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Security Clearance Rejected On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181670725258656219)
,p_db_column_name=>'SECURITY_CLEARANCE_REJECTED_BY'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'Security Clearance Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181670895533656220)
,p_db_column_name=>'SERVICE_AGREEMENT_STATUS'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Service Agreement Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181670900555656221)
,p_db_column_name=>'SERVICE_AGREEMENT_SUBMITTED_ON'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Service Agreement Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181671083769656222)
,p_db_column_name=>'SERVICE_AGREEMENT_SUBMITTED_BY'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Service Agreement Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181671170211656223)
,p_db_column_name=>'SERVICE_AGREEMENT_FINAL_APPROVED_ON'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'Service Agreement Final Approved On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181671252547656224)
,p_db_column_name=>'SERVICE_AGREEMENT_FINAL_APPROVED_BY'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Service Agreement Final Approved By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181671368764656225)
,p_db_column_name=>'SERVICE_AGREEMENT_REJECTED_ON'
,p_display_order=>630
,p_column_identifier=>'BK'
,p_column_label=>'Service Agreement Rejected On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181671486774656226)
,p_db_column_name=>'SERVICE_AGREEMENT_REJECTED_BY'
,p_display_order=>640
,p_column_identifier=>'BL'
,p_column_label=>'Service Agreement Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181671536412656227)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>650
,p_column_identifier=>'BM'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181671688065656228)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>660
,p_column_identifier=>'BN'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181671778033656229)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>670
,p_column_identifier=>'BO'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181671818584656230)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>680
,p_column_identifier=>'BP'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181671989677656231)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>690
,p_column_identifier=>'BQ'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181672093645656232)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>700
,p_column_identifier=>'BR'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(36664110333548073)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181672163257656233)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>710
,p_column_identifier=>'BS'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181672202491656234)
,p_db_column_name=>'TITLE'
,p_display_order=>720
,p_column_identifier=>'BT'
,p_column_label=>'Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181672396312656235)
,p_db_column_name=>'SEX'
,p_display_order=>730
,p_column_identifier=>'BU'
,p_column_label=>'Sex'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181672469589656236)
,p_db_column_name=>'PERSON_TYPE_ID'
,p_display_order=>740
,p_column_identifier=>'BV'
,p_column_label=>'Person Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(181672543524656237)
,p_db_column_name=>'PERSON_CATEGORY_ID'
,p_display_order=>750
,p_column_identifier=>'BW'
,p_column_label=>'Person Category Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(192704494984777628)
,p_db_column_name=>'END_USER_ID'
,p_display_order=>760
,p_column_identifier=>'BX'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(181755193271897536)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(181718876398778540)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1817189'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NUMBER:FULL_NAME:LICENSE_AVAILABLE_YN:LICENSE_EXEMPTION_YN:LOCATION_ID:LINE_MAANAGER_ID:PROJECT_DESCRIPTION:CONTRACT_DURATION_ID:SECURITY_CLEARANCE_REQUIRED_YN:IT_REQUIRED_YN:ACCESS_CARD_REQUIRED_YN:EMAIL:STATUS:END_USER_ID:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(179774768474432431)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(179774621659432430)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(36093683257523097)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Freelancer'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:30::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
