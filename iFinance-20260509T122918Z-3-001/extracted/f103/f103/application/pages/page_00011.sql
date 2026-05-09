prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
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
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Credit Cards Requests - Drilldown'
,p_alias=>'CREDIT-CARDS-REQUESTS-DRILLDOWN'
,p_step_title=>'Credit Cards Requests - Drilldown'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220303075558'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34742899095783156)
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
 p_id=>wwv_flow_api.id(34743489251783154)
,p_plug_name=>'Credit Cards Requests - Drilldown'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CREDIT_CARDS'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'dct_approval_status != case :P11_DOA_STATUS',
'    When ''All''',
'        Then ''Draft''',
'    End',
'or dct_approval_status = :P11_DOA_STATUS',
'and BANK_APPROVAL_STATUS = nvl(:P11_FINANCE_STATUS, BANK_APPROVAL_STATUS)'))
,p_query_order_by=>'UPDATED_ON DESC'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P11_DOA_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_document_header=>'SERVER'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Credit Cards Requests'
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
,p_prn_header_font_size=>'14'
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
 p_id=>wwv_flow_api.id(34743541872783154)
,p_name=>'Credit Cards Requests - Drilldown'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>34743541872783154
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34743910292783149)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34744228119783147)
,p_db_column_name=>'CREATOR_PERSON_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34744694107783147)
,p_db_column_name=>'REQUESTOR_PERSON_ID'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Requestor'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34745013351783146)
,p_db_column_name=>'REQUESTOR_ORG_ID'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Organization'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24146367401244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34745456359783146)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24146367401244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34745897771783146)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24140385314244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34746227790783146)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34746631912783145)
,p_db_column_name=>'PURPOSE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34747095525783145)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34747451913783145)
,p_db_column_name=>'APPROVED_AMOUNT'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Approved Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34747896070783145)
,p_db_column_name=>'EMPLOYEE_NUMBER'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Employee Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34748270424783144)
,p_db_column_name=>'MOTHER_NAME'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Mother Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34748696971783144)
,p_db_column_name=>'EMAIL'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34749004248783144)
,p_db_column_name=>'MOBILE_NUMBER'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Mobile Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34749470182783144)
,p_db_column_name=>'OFFICE_NUMBER'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Office Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34749844919783143)
,p_db_column_name=>'POSITION_NAME'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Position Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34750279943783143)
,p_db_column_name=>'POSITION_ID'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Position Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34750687883783143)
,p_db_column_name=>'ADCB_CUSTOMER_YN'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'ADCB Customer ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(24160177889244781)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34751081393783143)
,p_db_column_name=>'ADCB_MOBILE_REGISTERED'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'ADCB Mobile Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34751419067783142)
,p_db_column_name=>'ADCB_EMAIL_REGISTERED'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'ADCB Email Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34751851403783142)
,p_db_column_name=>'DCT_APPROVAL_STATUS'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'DOA Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34752249136783142)
,p_db_column_name=>'BANK_APPROVAL_STATUS'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Finance Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34752617721783142)
,p_db_column_name=>'NOTES'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34753006952783141)
,p_db_column_name=>'BIRTH_DATE'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Birth Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34753425341783141)
,p_db_column_name=>'SEX'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Gender'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(38586911582233520)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34753805845783141)
,p_db_column_name=>'PASSPORT_NO'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Passport No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34754217751783141)
,p_db_column_name=>'PASSPORT_EXPIRE_DATE'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Passport Expire Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34754637086783140)
,p_db_column_name=>'UAE_RESIDENCE_NO'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'UAE Residence No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34755095908783140)
,p_db_column_name=>'UAE_RESIDENCE_EXPIRE_DATE'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'UAE Residence Expire Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34755489429783140)
,p_db_column_name=>'EMIRATES_ID'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Emirates ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34755886864783140)
,p_db_column_name=>'EMIRATES_ID_EXPIRE_DATE'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Emirates ID Expire Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34756276020783139)
,p_db_column_name=>'NATIONALITY_ID'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Nationality'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(34273852203859543)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34756659242783139)
,p_db_column_name=>'PRINTED_NAME'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Printed Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34757077307783139)
,p_db_column_name=>'SUBMISSION_DATE'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Submission Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34757491167783139)
,p_db_column_name=>'FINAL_DCT_APPROVAL'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Final DCT Approval'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34757827028783138)
,p_db_column_name=>'FINAL_BANK_APPROVAL'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Final Finance Approval'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34758263804783138)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34758657344783138)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34759058681783138)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34759443182783137)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>40
,p_column_identifier=>'AN'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34759877581783137)
,p_db_column_name=>'FULL_NAME'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Full Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34760294083783137)
,p_db_column_name=>'EMPLOYEE_ID'
,p_display_order=>42
,p_column_identifier=>'AP'
,p_column_label=>'Employee Id'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(34762017620746964)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'347621'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUMBER:REQUESTOR_PERSON_ID:DEPARTMENT_ID:SECTOR_ID:REQUESTED_AMOUNT:EMAIL:NATIONALITY_ID:DCT_APPROVAL_STATUS:BANK_APPROVAL_STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(21111299857683634)
,p_report_id=>wwv_flow_api.id(34762017620746964)
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
 p_id=>wwv_flow_api.id(21110979803683634)
,p_report_id=>wwv_flow_api.id(34762017620746964)
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
,p_column_bg_color=>'#FFFFFF'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(21110574311683634)
,p_report_id=>wwv_flow_api.id(34762017620746964)
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
 p_id=>wwv_flow_api.id(21110144169683634)
,p_report_id=>wwv_flow_api.id(34762017620746964)
,p_name=>'DOA In-Progress '
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DCT_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("DCT_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34282526931651536)
,p_name=>'P11_DOA_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(34742899095783156)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34282647685651537)
,p_name=>'P11_FINANCE_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(34742899095783156)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
