prompt --application/pages/page_00016
begin
--   Manifest
--     PAGE: 00016
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>16
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'All Credit Cards Requests - Report'
,p_alias=>'ALL-CREDIT-CARDS-REQUESTS-REPORT'
,p_step_title=>'All Credit Cards Requests - Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220517193051'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38655963744271548)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23845862961372548)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(23782494216372596)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(23899958141372507)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38656538186271547)
,p_plug_name=>'All Credit Cards Requests'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       CREATOR_PERSON_ID,',
'       CREATED_BY_EMP_NAME,',
'       REQUESTOR_PERSON_ID,',
'       FULL_NAME_EN,',
'       REQUESTOR_ORG_ID,',
'       ORG_NAME,',
'       DEPARTMENT_ID,',
'       DEPARTMENT_NAME,',
'       SECTOR_ID,',
'       SECTOR,',
'       COST_CENTER,',
'       COST_CENTER_NAME,',
'       PURPOSE,',
'       AMOUNT,',
'       APPROVED_AMOUNT,',
'       EMPLOYEE_NUMBER,',
'       MOTHER_NAME,',
'       EMAIL,',
'       MOBILE_NUMBER,',
'       OFFICE_NUMBER,',
'       POSITION_NAME,',
'       POSITION_ID,',
'       ADCB_CUSTOMER_YN,',
'       ADCB_MOBILE_REGISTERED,',
'       ADCB_EMAIL_REGISTERED,',
'       DCT_APPROVAL_STATUS,',
'       BANK_APPROVAL_STATUS,',
'       NOTES,',
'       BIRTH_DATE,',
'       GENDER,',
'       PASSPORT_NO,',
'       PASSPORT_EXPIRE_DATE,',
'       UAE_RESIDENCE_NO,',
'       UAE_RESIDENCE_EXPIRE_DATE,',
'       EMIRATES_ID,',
'       EMIRATES_ID_EXPIRE_DATE,',
'       NATIONALITY_ID,',
'       NATIONALITY_NAME,',
'       PRINTED_NAME,',
'       SUBMISSION_DATE,',
'       FINAL_DCT_APPROVAL,',
'       FINAL_BANK_APPROVAL,',
'       CREATED_BY_PERSON_ID,',
'       CREATED_ON,',
'       UPDATED_BY_PERSON_ID,',
'       UPDATED_ON,',
'       FULL_NAME',
'  from CREDIT_CARDS_REQUESTS_V'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_document_header=>'SERVER'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Credit Cards Requests Report'
,p_prn_page_header_font_color=>'#062413'
,p_prn_page_header_font_family=>'Courier'
,p_prn_page_header_font_weight=>'bold'
,p_prn_page_header_font_size=>'14'
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
 p_id=>wwv_flow_api.id(38656612599271547)
,p_name=>'All Credit Cards Requests - Report'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>38656612599271547
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38657819363271465)
,p_db_column_name=>'CREATED_BY_EMP_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38658680840271464)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Full Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38659480348271464)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38660228813271463)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38661051339271463)
,p_db_column_name=>'SECTOR'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38661483912271462)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38661838731271462)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38662287624271462)
,p_db_column_name=>'PURPOSE'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38662629743271462)
,p_db_column_name=>'AMOUNT'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38663002333271461)
,p_db_column_name=>'EMPLOYEE_NUMBER'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38663477495271461)
,p_db_column_name=>'MOTHER_NAME'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Mother Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38663842093271461)
,p_db_column_name=>'EMAIL'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38664270204271461)
,p_db_column_name=>'MOBILE_NUMBER'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Mobile Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38664674829271460)
,p_db_column_name=>'OFFICE_NUMBER'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Office Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38665046313271460)
,p_db_column_name=>'POSITION_NAME'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Position Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38665803471271460)
,p_db_column_name=>'ADCB_CUSTOMER_YN'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'ADCB Customer  ?'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38666274927271459)
,p_db_column_name=>'ADCB_MOBILE_REGISTERED'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'ADCB Mobile Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38666630148271459)
,p_db_column_name=>'ADCB_EMAIL_REGISTERED'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'ADCB Email Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38667055662271459)
,p_db_column_name=>'DCT_APPROVAL_STATUS'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'DOA Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38667433828271459)
,p_db_column_name=>'BANK_APPROVAL_STATUS'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Finance Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38667888153271458)
,p_db_column_name=>'NOTES'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38668278770271458)
,p_db_column_name=>'BIRTH_DATE'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Birth Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38668640272271458)
,p_db_column_name=>'GENDER'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Gender'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(38586911582233520)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38669050747271458)
,p_db_column_name=>'PASSPORT_NO'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Passport No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38669419052271458)
,p_db_column_name=>'PASSPORT_EXPIRE_DATE'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Passport Expire Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38669818649271457)
,p_db_column_name=>'UAE_RESIDENCE_NO'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'UAE Residence No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38670243697271457)
,p_db_column_name=>'UAE_RESIDENCE_EXPIRE_DATE'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'UAE Residence Expire Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38671075584271457)
,p_db_column_name=>'EMIRATES_ID_EXPIRE_DATE'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Emirates ID Expire Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38671883890271456)
,p_db_column_name=>'PRINTED_NAME'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Printed Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672267123271456)
,p_db_column_name=>'SUBMISSION_DATE'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Submission Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38672662491271456)
,p_db_column_name=>'FINAL_DCT_APPROVAL'
,p_display_order=>40
,p_column_identifier=>'AN'
,p_column_label=>'Final DOA Approval'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38673057864271455)
,p_db_column_name=>'FINAL_BANK_APPROVAL'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Final Finance Approval'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38673470641271455)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>42
,p_column_identifier=>'AP'
,p_column_label=>'Created By Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38673871114271455)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>43
,p_column_identifier=>'AQ'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674218497271455)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>44
,p_column_identifier=>'AR'
,p_column_label=>'Updated By Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38674614166271454)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>45
,p_column_identifier=>'AS'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38675030528271454)
,p_db_column_name=>'FULL_NAME'
,p_display_order=>46
,p_column_identifier=>'AT'
,p_column_label=>'Full Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38657093640271466)
,p_db_column_name=>'ID'
,p_display_order=>56
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38657438022271465)
,p_db_column_name=>'CREATOR_PERSON_ID'
,p_display_order=>66
,p_column_identifier=>'B'
,p_column_label=>'Creator Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38658211645271464)
,p_db_column_name=>'REQUESTOR_PERSON_ID'
,p_display_order=>76
,p_column_identifier=>'D'
,p_column_label=>'Requestor Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38659082084271464)
,p_db_column_name=>'REQUESTOR_ORG_ID'
,p_display_order=>86
,p_column_identifier=>'F'
,p_column_label=>'Requestor Org Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38659890654271463)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>96
,p_column_identifier=>'H'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38660609379271463)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>106
,p_column_identifier=>'J'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38665495581271460)
,p_db_column_name=>'POSITION_ID'
,p_display_order=>116
,p_column_identifier=>'V'
,p_column_label=>'Position Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38671456654271456)
,p_db_column_name=>'NATIONALITY_ID'
,p_display_order=>126
,p_column_identifier=>'AK'
,p_column_label=>'Nationality Id'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9523454232196450)
,p_db_column_name=>'APPROVED_AMOUNT'
,p_display_order=>136
,p_column_identifier=>'AU'
,p_column_label=>'Approved Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9523307804196449)
,p_db_column_name=>'EMIRATES_ID'
,p_display_order=>146
,p_column_identifier=>'AV'
,p_column_label=>'Emirates Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9523224937196448)
,p_db_column_name=>'NATIONALITY_NAME'
,p_display_order=>156
,p_column_identifier=>'AW'
,p_column_label=>'Nationality Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(38675460627271096)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'386755'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FULL_NAME_EN:EMPLOYEE_NUMBER:DEPARTMENT_NAME:SECTOR:AMOUNT:DCT_APPROVAL_STATUS:BANK_APPROVAL_STATUS:APPROVED_AMOUNT:EMIRATES_ID:NATIONALITY_NAME'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(9355154061338495)
,p_report_id=>wwv_flow_api.id(38675460627271096)
,p_name=>'Finance Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BANK_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("BANK_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(9354736732338495)
,p_report_id=>wwv_flow_api.id(38675460627271096)
,p_name=>'Finance Not Started'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BANK_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Not Started'
,p_condition_sql=>' (case when ("BANK_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Not Started''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(9354329151338495)
,p_report_id=>wwv_flow_api.id(38675460627271096)
,p_name=>'DOA Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DCT_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("DCT_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(9353961527338496)
,p_report_id=>wwv_flow_api.id(38675460627271096)
,p_name=>'DOA Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DCT_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("DCT_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
);
wwv_flow_api.component_end;
end;
/
