prompt --application/pages/page_00021
begin
--   Manifest
--     PAGE: 00021
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>21
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Credit Card View'
,p_alias=>'CREDIT-CARD-VIEW'
,p_step_title=>'Credit Card View'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220313102639'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(25158053106138440)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(25155859074138418)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(25158053106138440)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23819444978372562)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24713888105849191)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23845862961372548)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(23782494216372596)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(23899958141372507)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(17746834012098036)
,p_plug_name=>'Previous requests'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(17746778757098035)
,p_plug_name=>'requests report'
,p_parent_plug_id=>wwv_flow_api.id(17746834012098036)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    creator_person_id,',
'    requestor_person_id,',
'    requestor_org_id,',
'    department_id,',
'    sector_id,',
'    cost_center,',
'    purpose,',
'    requested_amount,',
'    approved_amount,',
'    employee_number,',
'    mother_name,',
'    email,',
'    mobile_number,',
'    office_number,',
'    position_name,',
'    position_id,',
'    adcb_customer_yn,',
'    adcb_mobile_registered,',
'    adcb_email_registered,',
'    dct_approval_status,',
'    bank_approval_status,',
'    notes,',
'    birth_date,',
'    sex,',
'    passport_no,',
'    passport_expire_date,',
'    uae_residence_no,',
'    uae_residence_expire_date,',
'    emirates_id,',
'    emirates_id_expire_date,',
'    nationality_id,',
'    printed_name,',
'    submission_date,',
'    final_dct_approval,',
'    final_bank_approval,',
'    created_by_person_id,',
'    created_on,',
'    updated_by_person_id,',
'    updated_on,',
'    full_name,',
'    employee_id,',
'    approval_type,',
'    target_amount',
'--    filename,',
'--    file_mimetype,',
'--    file_charset,',
'--    file_blob,',
'--    created_by_request_id',
'FROM',
'    credit_cards',
'where created_by_request_id = :P21_CREDIT_CARD_ID',
'order by updated_on desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P21_CREDIT_CARD_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'requests report'
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
 p_id=>wwv_flow_api.id(17746600588098034)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No previous requests'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>99059698886827320
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17746567110098033)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17746491482098032)
,p_db_column_name=>'CREATOR_PERSON_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17746355092098031)
,p_db_column_name=>'REQUESTOR_PERSON_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Requested for'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17746295832098030)
,p_db_column_name=>'REQUESTOR_ORG_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Organization'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24140385314244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17746111982098029)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24140385314244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17746049081098028)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24140385314244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17745906650098027)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17745869530098026)
,p_db_column_name=>'PURPOSE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17745760793098025)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17745688184098024)
,p_db_column_name=>'APPROVED_AMOUNT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Approved Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17745500813098023)
,p_db_column_name=>'EMPLOYEE_NUMBER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Employee Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17745434510098022)
,p_db_column_name=>'MOTHER_NAME'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Mother Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17745366201098021)
,p_db_column_name=>'EMAIL'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17745254020098020)
,p_db_column_name=>'MOBILE_NUMBER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Mobile Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17745103916098019)
,p_db_column_name=>'OFFICE_NUMBER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Office Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17745058600098018)
,p_db_column_name=>'POSITION_NAME'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Position Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17744911635098017)
,p_db_column_name=>'POSITION_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Position Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17744889070098016)
,p_db_column_name=>'ADCB_CUSTOMER_YN'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Adcb Customer Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17744750126098015)
,p_db_column_name=>'ADCB_MOBILE_REGISTERED'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'ADCB Mobile Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17744657706098014)
,p_db_column_name=>'ADCB_EMAIL_REGISTERED'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'ABCD  Email Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17744518602098013)
,p_db_column_name=>'DCT_APPROVAL_STATUS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17744453061098012)
,p_db_column_name=>'BANK_APPROVAL_STATUS'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Bank Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17744374192098011)
,p_db_column_name=>'NOTES'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17744252207098010)
,p_db_column_name=>'BIRTH_DATE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Birth Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17744168549098009)
,p_db_column_name=>'SEX'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Gender'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_api.id(38586911582233520)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17744084133098008)
,p_db_column_name=>'PASSPORT_NO'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Passport No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17743903194098007)
,p_db_column_name=>'PASSPORT_EXPIRE_DATE'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Passport Expire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17743874112098006)
,p_db_column_name=>'UAE_RESIDENCE_NO'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'UAE Residence No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17743783804098005)
,p_db_column_name=>'UAE_RESIDENCE_EXPIRE_DATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'UAE Residence Expire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17743681956098004)
,p_db_column_name=>'EMIRATES_ID'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Emirates ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17488155679713953)
,p_db_column_name=>'EMIRATES_ID_EXPIRE_DATE'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Emirates ID Expire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17488064022713952)
,p_db_column_name=>'NATIONALITY_ID'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Nationality '
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(34273852203859543)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17487968736713951)
,p_db_column_name=>'PRINTED_NAME'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Printed Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17487896032713950)
,p_db_column_name=>'SUBMISSION_DATE'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Submission Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17487759598713949)
,p_db_column_name=>'FINAL_DCT_APPROVAL'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Final DCT Approval'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17487660643713948)
,p_db_column_name=>'FINAL_BANK_APPROVAL'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Final Bank Approval'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17487565287713947)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17487477022713946)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17487388236713945)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Updated By '
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17487221797713944)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17487157501713943)
,p_db_column_name=>'FULL_NAME'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Full Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17487085777713942)
,p_db_column_name=>'EMPLOYEE_ID'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Employee ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17486975840713941)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Request Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24669503372330760)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(17486857124713940)
,p_db_column_name=>'TARGET_AMOUNT'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Target Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(17467912168711010)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'993384'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'APPROVAL_TYPE:CREATOR_PERSON_ID:DEPARTMENT_ID:PURPOSE:REQUESTED_AMOUNT:DCT_APPROVAL_STATUS:BANK_APPROVAL_STATUS:NOTES:PRINTED_NAME:SUBMISSION_DATE:FINAL_DCT_APPROVAL:FINAL_BANK_APPROVAL:TARGET_AMOUNT:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25155689901138416)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(24713888105849191)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:21::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25155533175138415)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(24713888105849191)
,p_button_name=>'Process'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Process'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22:P22_CREDIT_CARD_ID:&P21_CREDIT_CARD_ID.'
,p_button_condition=>':P21_STATUS not in (''Active'', ''in-Active'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25157894764138438)
,p_name=>'P21_CREDIT_CARD_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25157707501138437)
,p_name=>'P21_HOLDER_NAME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'Card Holder'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25157627576138436)
,p_name=>'P21_HOLDER_PERSON_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25157546702138435)
,p_name=>'P21_EXPIRED_DATE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'Expired Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25157474964138434)
,p_name=>'P21_EMAIL'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'Email'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25157314297138433)
,p_name=>'P21_CREDIT_LIMIT'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'Credit Limit'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25157273535138432)
,p_name=>'P21_DEPARTMENT_ID'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'Department'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORG DETAILS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select org_name || '' ('' || org_level || '') ''  organization, ',
'        org_id , ',
'        department_name , ',
'        sector ,',
'        (select s.short_name_en',
'            from dct_hr_organizations s',
'            where s.org_name_en = organizations_details_v.sector',
'            and ROWNUM = 1)  sector_code',
'from organizations_details_v',
'order by sector , department_name, org_name;    '))
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25157132228138431)
,p_name=>'P21_SECTOR_ID'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORG DETAILS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select org_name || '' ('' || org_level || '') ''  organization, ',
'        org_id , ',
'        department_name , ',
'        sector ,',
'        (select s.short_name_en',
'            from dct_hr_organizations s',
'            where s.org_name_en = organizations_details_v.sector',
'            and ROWNUM = 1)  sector_code',
'from organizations_details_v',
'order by sector , department_name, org_name;    '))
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25157059328138430)
,p_name=>'P21_COST_CENTER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25156997404138429)
,p_name=>'P21_ADCB_CUSTOMER_YN'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'ADCB Customer ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_LOV'
,p_lov=>'.'||wwv_flow_api.id(24160177889244781)||'.'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25156815753138428)
,p_name=>'P21_ADCB_MOBILE_REGISTERED'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'ADCB Mobile Registered'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25156768283138427)
,p_name=>'P21_ADCB_EMAIL_REGISTERED'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'ADCB Email Registered'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25156618493138426)
,p_name=>'P21_NOTES'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'Notes'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25156500590138425)
,p_name=>'P21_CREATED_BY_REQUEST_ID'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'Created By Request'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25156446613138424)
,p_name=>'P21_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(25155859074138418)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEE NAME BY PERSONID LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from dct_employees_list2'))
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25156317520138423)
,p_name=>'P21_CREATED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(25155859074138418)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25156223157138422)
,p_name=>'P21_UPDATED_BY'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(25155859074138418)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEE NAME BY PERSONID LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from dct_employees_list2'))
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25156142838138421)
,p_name=>'P21_UPDATED_ON'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(25155859074138418)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25156000525138420)
,p_name=>'P21_STATUS'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(25158053106138440)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'STATUS LOV'
,p_lov=>'.'||wwv_flow_api.id(24157293190244783)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(25155967077138419)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Credit Card details process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    holder_person_id,',
'    holder_name,',
'    expired_date,',
'    email,',
'    to_char(credit_limit,''99,999,999,999.99'')credit_limit,',
'    department_id,',
'    sector_id,',
'    cost_center,',
'    adcb_customer_yn,',
'    adcb_mobile_registered,',
'    adcb_email_registered,',
'    notes,',
'    created_by_request_id,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    status',
'INTO',
'    :P21_CREDIT_CARD_ID,',
'    :P21_HOLDER_PERSON_ID,',
'    :P21_HOLDER_NAME,',
'    :P21_EXPIRED_DATE,',
'    :P21_EMAIL,',
'    :P21_CREDIT_LIMIT,',
'    :P21_DEPARTMENT_ID,',
'    :P21_SECTOR_ID,',
'    :P21_COST_CENTER,',
'    :P21_ADCB_CUSTOMER_YN,',
'    :P21_ADCB_MOBILE_REGISTERED,',
'    :P21_ADCB_EMAIL_REGISTERED,',
'    :P21_NOTES,',
'    :P21_CREATED_BY_REQUEST_ID,',
'    :P21_CREATED_BY,',
'    :P21_CREATED_ON,',
'    :P21_UPDATED_BY,',
'    :P21_UPDATED_ON,',
'    :P21_STATUS',
'FROM',
'    credit_cards_all',
'where id = :P21_CREDIT_CARD_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
