prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Missions Home'
,p_alias=>'MISSIONS-HOME'
,p_step_title=>'Missions/Training Requests Home'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA1810'
,p_last_upd_yyyymmddhh24miss=>'20240320094407'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(84397693966618527)
,p_plug_name=>'Information Missing'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>wwv_flow_api.id(12867655137762088)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>&nbsp;</p>',
'<p>Your Oracle HR record is not completed. Please contact HR team to define your:</p>',
'<ol>',
'<li>- Cost Center</li>',
'<li>- Grade</li>',
'<li>- Location</li>',
'<li>- Payroll Area&nbsp;</li>',
'</ol>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P3_COST_CENTER_CODE_H is Null or ',
':P3_LOCATION_ID_H is Null or',
':P3_GRADE_ID_H is Null or',
':P3_PAYROLL_AREA_ID_H is Null'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(109803400656053796)
,p_plug_name=>'Breadcrumb'
,p_icon_css_classes=>'fa-universal-access'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(109997154834785306)
,p_plug_name=>'My &P3_TYPE.'
,p_icon_css_classes=>'fa-user'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(251101005573039)
,p_plug_name=>'My Missions Report'
,p_parent_plug_id=>wwv_flow_api.id(109997154834785306)
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select REQUEST_ID,',
'       REQUEST_NO,',
'       REQUEST_DATE,',
'       REQUEST_FOR,',
'       GRADE_CODE,',
'       GRADE_RATE,',
'       OVERSEAS_YN,',
'       EMIRATE,',
'       FULL_DAY_YN,',
'       TRAVEL_ABOVE_10HR_YN,',
'       TICKET_REQUEST,',
'       HOSPITALITY_YN,',
'       TRANSPORTATION,',
'       START_DATE,',
'       END_DATE,',
'       REQUEST_STATUS,',
'       COMPLETE_STATUS,',
'       JUSTIFICATION,',
'       YEAR,',
'       PURPOSE_EU,',
'       PRIORITY,',
'       SUBMITTED_ON,',
'       SUBMITTED_BY,',
'       SEQ,',
'       FINAL_APPROVE_ON,',
'       REQUEST_TYPE,',
'       FINAL_REJECT_ON,',
'       REJECTED_BY,',
'       REJECT_REASON,',
'       CANCEL_ON,',
'       CANCELLED_BY,',
'       CANCEL_REASON,',
'       APPROVAL_TYPE_ID,',
'       CREATED_BY_PERSON_ID,',
'       UPDATED_BY_PERSON_ID,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       MISSION_UTIL.get_mission_amount(REQUEST_ID)    AMOUNT,',
'       APPROVAL_TYPE,',
'       COST_CENTER,',
'       CONFIRMED_start_DATE,',
'       CONFIRMED_END_DATE,',
'       CONFIRMED_COMMENT',
'  from MISSION_HEADER',
'  where (CREATED_BY_PERSON_ID = :PERSON_ID ',
'  or REQUEST_FOR =:PERSON_ID)',
'  and REQUEST_TYPE = :P3_TYPE_CODE'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P3_TYPE_CODE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'My Missions Report'
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
 p_id=>wwv_flow_api.id(251179854573040)
,p_max_row_count=>'1000000'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>110862056344580017
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(251251477573041)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(251374769573042)
,p_db_column_name=>'FINAL_REJECT_ON'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Final Reject On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(251500190573043)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(251610763573044)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(251674425573045)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(251791695573046)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(251865656573047)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(251950741573048)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(252097404573049)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(252161667573050)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(252267333573051)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(252370260573052)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(252580571573054)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(252696155573055)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(252794445573056)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::P13_REQUEST_ID,REQUEST_ID,P13_PAGE_FROM,REQUEST_ID:#REQUEST_ID#,#REQUEST_ID#,3,#REQUEST_ID#'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(252905725573057)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(252977170573058)
,p_db_column_name=>'REQUEST_FOR'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(253102061573059)
,p_db_column_name=>'GRADE_CODE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Grade'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109823118131928448)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(253206421573060)
,p_db_column_name=>'GRADE_RATE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Grade Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(253287799573061)
,p_db_column_name=>'OVERSEAS_YN'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Overseas ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(253403200573062)
,p_db_column_name=>'EMIRATE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Emirate'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109829266094654960)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(253453742573063)
,p_db_column_name=>'FULL_DAY_YN'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Full Day ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(253590607573064)
,p_db_column_name=>'TRAVEL_ABOVE_10HR_YN'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Travel Above 10hr ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(253645226573065)
,p_db_column_name=>'TICKET_REQUEST'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Ticket Request'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109829432214610256)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(253738941573066)
,p_db_column_name=>'HOSPITALITY_YN'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Hospitality ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(253839299573067)
,p_db_column_name=>'TRANSPORTATION'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Transportation'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109830333459518310)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(254006875573068)
,p_db_column_name=>'START_DATE'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(254081901573069)
,p_db_column_name=>'END_DATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(254215427573070)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Request Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(254309751573071)
,p_db_column_name=>'COMPLETE_STATUS'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Confirmation Status'
,p_column_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23:P23_REQUEST_ID,P23_CONFIRMED_STATUS,P23_REQUEST_NUMBER:#REQUEST_ID#,#COMPLETE_STATUS#,#REQUEST_NO#'
,p_column_linktext=>'#COMPLETE_STATUS#'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(254381675573072)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(254474791573073)
,p_db_column_name=>'YEAR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(320369785690524)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Purpose'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(320516187690525)
,p_db_column_name=>'PRIORITY'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109815946584935965)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(320563059690526)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(320637777690527)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(320823475690528)
,p_db_column_name=>'SEQ'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(320907753690529)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(320985980690530)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(110033950814469886)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4167924608042861)
,p_db_column_name=>'AMOUNT'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97910211531754134)
,p_db_column_name=>'CONFIRMED_START_DATE'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Confirmed Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97910228013754135)
,p_db_column_name=>'CONFIRMED_END_DATE'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Confirmed End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97910406521754136)
,p_db_column_name=>'CONFIRMED_COMMENT'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Confirmation Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(337875118684268)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1109488'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:REQUEST_FOR:GRADE_CODE:OVERSEAS_YN:HOSPITALITY_YN:START_DATE:CONFIRMED_START_DATE:END_DATE:CONFIRMED_END_DATE:COMPLETE_STATUS:AMOUNT:REQUEST_STATUS:'
,p_sort_column_1=>'UPDATED_DATE'
,p_sort_direction_1=>'DESC'
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
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(128788317799503166)
,p_report_id=>wwv_flow_api.id(337875118684268)
,p_name=>'Confirmed'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'COMPLETE_STATUS'
,p_operator=>'='
,p_expr=>'Confirmed'
,p_condition_sql=>' (case when ("COMPLETE_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Confirmed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(128788652851503166)
,p_report_id=>wwv_flow_api.id(337875118684268)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(128789024607503165)
,p_report_id=>wwv_flow_api.id(337875118684268)
,p_name=>'Reject'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(345012692588186)
,p_application_user=>'TCA1384'
,p_name=>'simple'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:REQUEST_FOR:GRADE_CODE:GRADE_RATE:OVERSEAS_YN:START_DATE:END_DATE:REQUEST_STATUS:COMPLETE_STATUS:JUSTIFICATION'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(109997278607785307)
,p_plug_name=>'All &P3_TYPE.'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_COMPENSATION_BENIFIT_YN = ''Y''',
'or',
':IS_PAYROLL_ADMIN = ''Y'' ',
'or ',
':PERSON_ID = 680461',
'or ',
':IS_FBP_YN  = ''Y''',
'or',
':VIEW_ALL_DUTY_YN = ''Y'''))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(109997399558785308)
,p_plug_name=>'Missions Reports'
,p_parent_plug_id=>wwv_flow_api.id(109997278607785307)
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select mh.REQUEST_ID,',
'       mh.REQUEST_NO,',
'       mh.REQUEST_DATE,',
'       mh.REQUEST_FOR,',
'       e.employee_num,',
'       e.sector,',
'       e.department_name,',
'       e.org_name,',
'       mh.GRADE_CODE,',
'       mh.GRADE_RATE,',
'       mh.OVERSEAS_YN,',
'       mh.EMIRATE,',
'       mh.FULL_DAY_YN,',
'       mh.TRAVEL_ABOVE_10HR_YN,',
'       mh.TICKET_REQUEST,',
'       mh.HOSPITALITY_YN,',
'       mh.TRANSPORTATION,',
'       mh.START_DATE,',
'       mh.END_DATE,',
'       mh.REQUEST_STATUS,',
'       mh.COMPLETE_STATUS,',
'       mh.JUSTIFICATION,',
'       mh.YEAR,',
'       mh.PURPOSE_EU,',
'       mh.PRIORITY,',
'       mh.SUBMITTED_ON,',
'       mh.SUBMITTED_BY,',
'       mh.SEQ,',
'       mh.FINAL_APPROVE_ON,',
'       mh.REQUEST_TYPE,',
'       mh.FINAL_REJECT_ON,',
'       mh.REJECTED_BY,',
'       mh.REJECT_REASON,',
'       mh.CANCEL_ON,',
'       mh.CANCELLED_BY,',
'       mh.CANCEL_REASON,',
'       mh.APPROVAL_TYPE_ID,',
'       mh.CREATED_BY_PERSON_ID,',
'       mh.UPDATED_BY_PERSON_ID,',
'       mh.CREATION_DATE,',
'       mh.UPDATED_DATE,',
'       MISSION_UTIL.get_mission_amount(mh.REQUEST_ID)    AMOUNT,',
'       mh.APPROVAL_TYPE,',
'       mh.COST_CENTER,',
'       mh.PV_NUMBER,',
'       mh.EXECUTED_STATUS initiated,',
'       mh.invoice_number,',
'       mh.invoice_date',
'  from MISSION_HEADER mh, employees_v e',
'  where mh.request_for = e.person_id',
'    and REQUEST_TYPE = :P3_TYPE_CODE',
'   -- and ou_code = :OU_CODE'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P3_TYPE_CODE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Missions Reports'
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
 p_id=>wwv_flow_api.id(109997469496785309)
,p_max_row_count=>'1000000'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>109997469496785309
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109997555127785310)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109997636493785311)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::P13_REQUEST_ID,REQUEST_ID,P13_PAGE_FROM,REQUEST_ID:#REQUEST_ID#,#REQUEST_ID#,3,#REQUEST_ID#'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109997725573785312)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109997879722785313)
,p_db_column_name=>'REQUEST_FOR'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109997907328785314)
,p_db_column_name=>'GRADE_CODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Grade'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109823118131928448)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109998047352785315)
,p_db_column_name=>'GRADE_RATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Grade Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109998121766785316)
,p_db_column_name=>'OVERSEAS_YN'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Overseas ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109998206322785317)
,p_db_column_name=>'EMIRATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Emirate'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109829266094654960)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109998387513785318)
,p_db_column_name=>'FULL_DAY_YN'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Full Day ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109998430587785319)
,p_db_column_name=>'TRAVEL_ABOVE_10HR_YN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Travel Above 10hr ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109998549717785320)
,p_db_column_name=>'TICKET_REQUEST'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Ticket Request'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109829432214610256)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109998691786785321)
,p_db_column_name=>'HOSPITALITY_YN'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Hospitality ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109998770981785322)
,p_db_column_name=>'TRANSPORTATION'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Transportation'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109830333459518310)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109998821747785323)
,p_db_column_name=>'START_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109998907885785324)
,p_db_column_name=>'END_DATE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109999010293785325)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Request Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109999112360785326)
,p_db_column_name=>'COMPLETE_STATUS'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Confirmation Status'
,p_column_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23:P23_CONFIRMED_STATUS,P23_REQUEST_ID,P23_REQUEST_NUMBER:#COMPLETE_STATUS#,#REQUEST_ID#,#REQUEST_NO#'
,p_column_linktext=>'#COMPLETE_STATUS#'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109999261089785327)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109999354877785328)
,p_db_column_name=>'YEAR'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Year'
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
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109999454622785329)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Purpose'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109999523321785330)
,p_db_column_name=>'PRIORITY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109815946584935965)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109999685210785331)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109999716433785332)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109999885455785333)
,p_db_column_name=>'SEQ'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109999983329785334)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110000037398785335)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(110033950814469886)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110000199531785336)
,p_db_column_name=>'FINAL_REJECT_ON'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Final Reject On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110000232260785337)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110000326689785338)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110000493461785339)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110000516322785340)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110000624648785341)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110000717147785342)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110000876984785343)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110000974944785344)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110001031743785345)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110001133750785346)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110399847810476419)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110399992411476420)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(85480431739639784)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4168069673042862)
,p_db_column_name=>'AMOUNT'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(961305928787857)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(961377473787858)
,p_db_column_name=>'SECTOR'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(961495896787859)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(961525195787860)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85707096830488639)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'PV Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(96257571735052843)
,p_db_column_name=>'INITIATED'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Initiated'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104050827361560265)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104050965297560266)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(110019872004576611)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1100199'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:REQUEST_FOR:COST_CENTER:EMPLOYEE_NUM:OVERSEAS_YN:START_DATE:END_DATE:AMOUNT:INVOICE_NUMBER:PV_NUMBER:COMPLETE_STATUS:REQUEST_STATUS:'
,p_sort_column_1=>'UPDATED_DATE'
,p_sort_direction_1=>'DESC NULLS LAST'
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
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(120282459513958887)
,p_report_id=>wwv_flow_api.id(110019872004576611)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'COMPLETE_STATUS'
,p_operator=>'='
,p_expr=>'Confirmed'
,p_condition_sql=>' (case when ("COMPLETE_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Confirmed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(120282828213958887)
,p_report_id=>wwv_flow_api.id(110019872004576611)
,p_name=>'Confirm'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'COMPLETE_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("COMPLETE_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(120283227423958886)
,p_report_id=>wwv_flow_api.id(110019872004576611)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(120283582534958886)
,p_report_id=>wwv_flow_api.id(110019872004576611)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(120283964507958886)
,p_report_id=>wwv_flow_api.id(110019872004576611)
,p_name=>'Return'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Return'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Return''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(120284333281958886)
,p_report_id=>wwv_flow_api.id(110019872004576611)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(90359370515276421)
,p_application_user=>'TCA9051'
,p_name=>'PV Numbers'
,p_report_seq=>10
,p_report_alias=>'2009703'
,p_status=>'PUBLIC'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:REQUEST_FOR:COST_CENTER:EMPLOYEE_NUM:OVERSEAS_YN:START_DATE:END_DATE:AMOUNT:PV_NUMBER:INITIATED:COMPLETE_STATUS:REQUEST_STATUS:'
,p_sort_column_1=>'UPDATED_DATE'
,p_sort_direction_1=>'DESC'
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
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(97476211477029292)
,p_report_id=>wwv_flow_api.id(90359370515276421)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'COMPLETE_STATUS'
,p_operator=>'='
,p_expr=>'Confirmed'
,p_condition_sql=>' (case when ("COMPLETE_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Confirmed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(97476601441029292)
,p_report_id=>wwv_flow_api.id(90359370515276421)
,p_name=>'Confirm'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'COMPLETE_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("COMPLETE_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(97476938163029293)
,p_report_id=>wwv_flow_api.id(90359370515276421)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(97477340564029293)
,p_report_id=>wwv_flow_api.id(90359370515276421)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(97477795943029293)
,p_report_id=>wwv_flow_api.id(90359370515276421)
,p_name=>'Return'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Return'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Return''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(97478151859029294)
,p_report_id=>wwv_flow_api.id(90359370515276421)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(97475763705029292)
,p_report_id=>wwv_flow_api.id(90359370515276421)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'PV_NUMBER'
,p_operator=>'is not null'
,p_condition_sql=>'"PV_NUMBER" is not null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(108535316604730448)
,p_application_user=>'TCA9051'
,p_name=>'Finance Nov Mission'
,p_report_seq=>10
,p_report_alias=>'2191462'
,p_status=>'PUBLIC'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:REQUEST_FOR:EMPLOYEE_NUM:COST_CENTER:OVERSEAS_YN:START_DATE:END_DATE:AMOUNT:INVOICE_NUMBER:PV_NUMBER:COMPLETE_STATUS:REQUEST_STATUS:PURPOSE_EU:'
,p_sort_column_1=>'UPDATED_DATE'
,p_sort_direction_1=>'DESC NULLS LAST'
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
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(108536414429730456)
,p_report_id=>wwv_flow_api.id(108535316604730448)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'COMPLETE_STATUS'
,p_operator=>'='
,p_expr=>'Confirmed'
,p_condition_sql=>' (case when ("COMPLETE_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Confirmed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(108536731649730456)
,p_report_id=>wwv_flow_api.id(108535316604730448)
,p_name=>'Confirm'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'COMPLETE_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("COMPLETE_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(108537194043730457)
,p_report_id=>wwv_flow_api.id(108535316604730448)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(108537541302730457)
,p_report_id=>wwv_flow_api.id(108535316604730448)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(108538015394730457)
,p_report_id=>wwv_flow_api.id(108535316604730448)
,p_name=>'Return'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Return'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Return''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(108538383934730457)
,p_report_id=>wwv_flow_api.id(108535316604730448)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(108535634832730455)
,p_report_id=>wwv_flow_api.id(108535316604730448)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'COST_CENTER'
,p_operator=>'='
,p_expr=>'(4510210) DCT - Finance Dept'
,p_condition_sql=>'"COST_CENTER" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''(4510210) DCT - Finance Dept''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(108536121740730456)
,p_report_id=>wwv_flow_api.id(108535316604730448)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'START_DATE'
,p_operator=>'between'
,p_expr=>'20231101000000'
,p_expr2=>'20231130000000'
,p_condition_sql=>'"START_DATE" between to_date(#APXWS_EXPR#,''YYYYMMDDHH24MISS'') and to_date(#APXWS_EXPR2#,''YYYYMMDDHH24MISS'')'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# #APXWS_EXPR_DATE# #APXWS_AND# #APXWS_EXPR2_DATE#'
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(91355148585896116)
,p_application_user=>'TCA1677'
,p_name=>'Weekly'
,p_report_seq=>10
,p_display_rows=>100
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:REQUEST_FOR:GRADE_CODE:COST_CENTER:EMPLOYEE_NUM:OVERSEAS_YN:START_DATE:END_DATE:COMPLETE_STATUS:AMOUNT:REQUEST_STATUS:'
,p_sort_column_1=>'UPDATED_DATE'
,p_sort_direction_1=>'DESC'
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
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(91355260082896118)
,p_report_id=>wwv_flow_api.id(91355148585896116)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'COMPLETE_STATUS'
,p_operator=>'='
,p_expr=>'Confirmed'
,p_condition_sql=>' (case when ("COMPLETE_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Confirmed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(91355347374896118)
,p_report_id=>wwv_flow_api.id(91355148585896116)
,p_name=>'Confirm'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'COMPLETE_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("COMPLETE_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(91355449381896118)
,p_report_id=>wwv_flow_api.id(91355148585896116)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(91355536693896118)
,p_report_id=>wwv_flow_api.id(91355148585896116)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(91355659927896118)
,p_report_id=>wwv_flow_api.id(91355148585896116)
,p_name=>'Return'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Return'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Return''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(91355813999896118)
,p_report_id=>wwv_flow_api.id(91355148585896116)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(102603816309404589)
,p_application_user=>'TCA1067'
,p_name=>'December Requests'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:REQUEST_FOR:COST_CENTER:EMPLOYEE_NUM:OVERSEAS_YN:START_DATE:END_DATE:AMOUNT:PV_NUMBER:COMPLETE_STATUS:REQUEST_STATUS:'
,p_sort_column_1=>'UPDATED_DATE'
,p_sort_direction_1=>'DESC NULLS LAST'
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
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(102603973951404590)
,p_report_id=>wwv_flow_api.id(102603816309404589)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'COMPLETE_STATUS'
,p_operator=>'='
,p_expr=>'Confirmed'
,p_condition_sql=>' (case when ("COMPLETE_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Confirmed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(102604055939404590)
,p_report_id=>wwv_flow_api.id(102603816309404589)
,p_name=>'Confirm'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'COMPLETE_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("COMPLETE_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(102604180291404590)
,p_report_id=>wwv_flow_api.id(102603816309404589)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(102604257452404590)
,p_report_id=>wwv_flow_api.id(102603816309404589)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(102604344087404590)
,p_report_id=>wwv_flow_api.id(102603816309404589)
,p_name=>'Return'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Return'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Return''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(102604445903404590)
,p_report_id=>wwv_flow_api.id(102603816309404589)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(102603855742404589)
,p_report_id=>wwv_flow_api.id(102603816309404589)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_DATE'
,p_operator=>'between'
,p_expr=>'20231201000000'
,p_expr2=>'20231231000000'
,p_condition_sql=>'"REQUEST_DATE" between to_date(#APXWS_EXPR#,''YYYYMMDDHH24MISS'') and to_date(#APXWS_EXPR2#,''YYYYMMDDHH24MISS'')'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# #APXWS_EXPR_DATE# #APXWS_AND# #APXWS_EXPR2_DATE#'
,p_enabled=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4999169336410371)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(109803400656053796)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--gapRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110001314357785348)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(109803400656053796)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12,13:P12_REQUEST_TYPE,P12_REQUEST_TYPE_DISPLAY:&P3_TYPE_CODE.,&P3_TYPE.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P3_COST_CENTER_CODE_H is not Null and',
':P3_LOCATION_ID_H is not  Null and',
':P3_GRADE_ID_H is not Null and',
':P3_PAYROLL_AREA_ID_H is not Null'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4998877024410368)
,p_name=>'P3_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(109803400656053796)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4999116476410370)
,p_name=>'P3_TYPE_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(109803400656053796)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84397767245618528)
,p_name=>'P3_COST_CENTER_CODE_H'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(84397693966618527)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84397837871618529)
,p_name=>'P3_LOCATION_ID_H'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(84397693966618527)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84398015095618530)
,p_name=>'P3_GRADE_ID_H'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(84397693966618527)
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
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84398036082618531)
,p_name=>'P3_PAYROLL_AREA_ID_H'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(84397693966618527)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(4998979728410369)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set request type'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P3_TYPE_CODE = ''M'' Then',
'        :P3_TYPE := ''Missions'';',
'   elsif',
'   :P3_TYPE_CODE = ''T'' Then',
'        :P3_TYPE := ''Training'';',
'end if;',
'       '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(84398130252618532)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Check Employee Details available'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select cost_center_code, location_id , grade_id, payroll_area_id',
'into :P3_COST_CENTER_CODE_H, :P3_LOCATION_ID_H, :P3_GRADE_ID_H , :P3_PAYROLL_AREA_ID_H',
'from employees_v',
'where person_id = :PERSON_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
