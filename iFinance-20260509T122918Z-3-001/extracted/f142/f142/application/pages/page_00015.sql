prompt --application/pages/page_00015
begin
--   Manifest
--     PAGE: 00015
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>142
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>15
,p_user_interface_id=>wwv_flow_api.id(159947477385220145)
,p_name=>'BM Requests'
,p_alias=>'BM-REQUESTS'
,p_step_title=>'BM Requests'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231012070255'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(194367319602508566)
,p_plug_name=>'BM Forms Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(159860948285220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select REQUEST_ID,',
'       REQUEST_NO,',
'       REQUEST_DATE,',
'       PROJECT_NUMBER,',
'       CONTRACT_NUMBER,',
'       HEADLINE_SCOPE,',
'       DEATILED_SCOPE,',
'       WORK_DATE,',
'--       WORK_DURATION_COUNT,',
'--       WORK_DURATION,',
'       WORK_DURATION_COUNT || '' '' ||  WORK_DURATION as work_duration,',
'       SCOPE_BASIS,',
'       SCOPE_BASIS_REF,',
'  --     EVALUATION_METHOD,',
'       CONTRACTOR_PROPOSED_AMOUNT,',
'       CONTRACTOR_PROPOSED_CURRENCY,',
'       CONTRACT_RATES_PCT,',
'       NEW_RATE_PCT,',
'       ENGINEER_ASSESSEMENT,',
'       ENGINEER_ASSESSEMENT_COMMENT,',
'       END_USER_PERSON_ID,',
'       APPROVAL_STATUS,',
'       YEAR,',
'       SEQ,',
'       PRIORITY,',
'       SUBMITTED_ON,',
'       SUBMITTED_BY,',
'       FINAL_APPROVE_ON,',
'       FINAL_REJECT_ON,',
'       REJECTED_BY,',
'       REJECT_REASON,',
'       CANCEL_ON,',
'       CANCELLED_BY,',
'       CANCEL_REASON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE',
'  from BM_REQUESTS'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'BM Forms Report'
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
 p_id=>wwv_flow_api.id(194367748135508566)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:RP:P16_REQUEST_ID:\#REQUEST_ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>194367748135508566
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194367845248508574)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194368249273508579)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'BM Ref'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194368663428508579)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Form Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194369036611508579)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194369401773508579)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194369840383508580)
,p_db_column_name=>'HEADLINE_SCOPE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Headline Scope'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194370242558508580)
,p_db_column_name=>'DEATILED_SCOPE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Deatiled Scope'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194370661736508580)
,p_db_column_name=>'WORK_DATE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Work Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194371440160508580)
,p_db_column_name=>'WORK_DURATION'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Work Duration'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194371819506508581)
,p_db_column_name=>'SCOPE_BASIS'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Scope Basis'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194372201215508581)
,p_db_column_name=>'SCOPE_BASIS_REF'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Scope Basis Ref'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194373093556508581)
,p_db_column_name=>'CONTRACTOR_PROPOSED_AMOUNT'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Contractor Proposed Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194373422833508581)
,p_db_column_name=>'CONTRACTOR_PROPOSED_CURRENCY'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194373864200508581)
,p_db_column_name=>'CONTRACT_RATES_PCT'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'%Age Value Using Contract Rates'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194374234892508582)
,p_db_column_name=>'NEW_RATE_PCT'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'%age Value Using New Rates'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194374643960508582)
,p_db_column_name=>'ENGINEER_ASSESSEMENT'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Engineer''s / ER''s Assessment'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194375038823508582)
,p_db_column_name=>'ENGINEER_ASSESSEMENT_COMMENT'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Engineer Assessment Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194375457787508582)
,p_db_column_name=>'END_USER_PERSON_ID'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'End User Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194375890872508582)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194376248986508583)
,p_db_column_name=>'YEAR'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194376629881508583)
,p_db_column_name=>'SEQ'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194377012142508583)
,p_db_column_name=>'PRIORITY'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194377460838508583)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194377878714508583)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194378223864508584)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194378674907508584)
,p_db_column_name=>'FINAL_REJECT_ON'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Final Reject On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194379013989508584)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194379407359508584)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194379808122508584)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194380250794508585)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194380644404508585)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194381062965508585)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194381473123508585)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194381879820508585)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(194382279644508585)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(194387220000529723)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1943873'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:PROJECT_NUMBER:CONTRACT_NUMBER:HEADLINE_SCOPE:DEATILED_SCOPE:WORK_DATE:WORK_DURATION:SCOPE_BASIS:SCOPE_BASIS_REF:CONTRACTOR_PROPOSED_AMOUNT:CONTRACTOR_PROPOSED_CURRENCY:CONTRACT_RATES_PCT:NEW_RATE_PCT:ENGINEER_ASSESSEMENT:ENGI'
||'NEER_ASSESSEMENT_COMMENT:APPROVAL_STATUS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(194383592295508614)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(159872296964220075)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(159808885281220038)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(159926330718220124)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(194384785145508616)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(194383592295508614)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'New Benchmark'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:16'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
