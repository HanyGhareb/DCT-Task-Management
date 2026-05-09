prompt --application/pages/page_00012
begin
--   Manifest
--     PAGE: 00012
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>12
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Mission Details'
,p_alias=>'MISSION-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'Mission Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230720064603'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1849644088296325)
,p_plug_name=>'Alert'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--wizard:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(12867655137762088)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><strong style="color: red;"> As Per People &amp; Performance policy, Pervious Mission / Training request Must be confirmed in order to Submit new request.</strong> For any help, please contact: <a href="mailto:AMatar@dctabudhabi.ae">Aysha Matar Al'
||' Dhaheri</a>.</p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4165077316042832)
,p_plug_name=>'Alert eligiblity'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--wizard:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(12867655137762088)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><strong style="color: red;"> As Per People &amp; Performance policy, The selected Employee is not eligible to raise Mission/Training request.</strong> For any help, please contact: <a href="mailto:AMatar@dctabudhabi.ae">Aysha Matar Al Dhaheri</a>.'
||'</p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110020617292559145)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(322342240690544)
,p_plug_name=>'Previous requests'
,p_parent_plug_id=>wwv_flow_api.id(110020617292559145)
,p_icon_css_classes=>'fa-history'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(322486811690545)
,p_plug_name=>'Previous requests Report'
,p_parent_plug_id=>wwv_flow_api.id(322342240690544)
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
'       AMOUNT,',
'       APPROVAL_TYPE,',
'       COST_CENTER',
'  from MISSION_HEADER',
'  where request_for = nvl(:P12_REQUEST_FOR,-1)',
'  and request_id != nvl(:P12_REQUEST_ID, -1)',
'  and (:P12_START_DATE between  start_date and END_DATE',
'  OR :P12_END_DATE between  start_date and END_DATE)',
'  order by START_DATE',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P12_REQUEST_FOR,P12_START_DATE,P12_END_DATE,P12_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Previous requests Report'
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
 p_id=>wwv_flow_api.id(322559713690546)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Missions / Training requests within the duration selected'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>110933436203697523
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(322663166690547)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(322769796690548)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(322846312690549)
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
 p_id=>wwv_flow_api.id(322942044690550)
,p_db_column_name=>'REQUEST_FOR'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(323096561690551)
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
 p_id=>wwv_flow_api.id(323163554690552)
,p_db_column_name=>'GRADE_RATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(323260801690553)
,p_db_column_name=>'OVERSEAS_YN'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Overseas ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(323360165690554)
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
 p_id=>wwv_flow_api.id(323433881690555)
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
 p_id=>wwv_flow_api.id(323607893690556)
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
 p_id=>wwv_flow_api.id(323686759690557)
,p_db_column_name=>'TICKET_REQUEST'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Ticket Request'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(323772292690558)
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
 p_id=>wwv_flow_api.id(323922448690559)
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
 p_id=>wwv_flow_api.id(324006574690560)
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
 p_id=>wwv_flow_api.id(324074208690561)
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
 p_id=>wwv_flow_api.id(324136328690562)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Request Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(324311571690563)
,p_db_column_name=>'COMPLETE_STATUS'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Complete Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(324365842690564)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(324683062690567)
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
 p_id=>wwv_flow_api.id(324807823690568)
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
 p_id=>wwv_flow_api.id(324918920690569)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(325069014690571)
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
 p_id=>wwv_flow_api.id(325315320690573)
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
 p_id=>wwv_flow_api.id(1025727551809124)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1025829472809125)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1025956282809126)
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
 p_id=>wwv_flow_api.id(1026034604809127)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1026221664809128)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1026311574809129)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1026419539809130)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1026506560809131)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1026538383809132)
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
 p_id=>wwv_flow_api.id(1026645388809133)
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
 p_id=>wwv_flow_api.id(1026752314809134)
,p_db_column_name=>'AMOUNT'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1026980110809136)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(324484021690565)
,p_db_column_name=>'YEAR'
,p_display_order=>410
,p_column_identifier=>'S'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(324583304690566)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>420
,p_column_identifier=>'T'
,p_column_label=>'Purpose Eu'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(325000948690570)
,p_db_column_name=>'SEQ'
,p_display_order=>430
,p_column_identifier=>'X'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1026874433809135)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>440
,p_column_identifier=>'AM'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(325181612690572)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>450
,p_column_identifier=>'Z'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1053893782760581)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1116648'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:REQUEST_FOR:START_DATE:END_DATE:JUSTIFICATION:AMOUNT:REQUEST_STATUS:COMPLETE_STATUS:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110023376472540818)
,p_plug_name=>'Button'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12872392429762094)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110023236456540817)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(110023376472540818)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Create'
,p_button_position=>'BELOW_BOX'
,p_button_condition=>'P12_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110105511151864246)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(110023376472540818)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110023443301540819)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(110023376472540818)
,p_button_name=>'UPDATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Apply Change'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P12_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(110024111343540826)
,p_branch_name=>'GO TO 13'
,p_branch_action=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::P13_REQUEST_ID:&P12_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(321797482690538)
,p_name=>'P12_EMP_EMIRATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_item_default=>'select user_details.get_emp_emirate(:person_id) from dual;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Location'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1849755424296326)
,p_name=>'P12_NOT_CONFIRMED'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4164520026042826)
,p_name=>'P12_ELIGIBALE_TO_REQUEST'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'I'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110001465499785349)
,p_name=>'P12_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110001542862785350)
,p_name=>'P12_REQUEST_NO'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'Request No'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P12_REQUEST_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110021683076540801)
,p_name=>'P12_REQUEST_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'Request Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P12_REQUEST_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110021740007540802)
,p_name=>'P12_REQUEST_FOR'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_prompt=>'Request For'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Employee'
,p_attribute_10=>'EMIRATE:P12_EMP_EMIRATE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110021833069540803)
,p_name=>'P12_OVERSEAS_YN'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'Overseas ?'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110021976032540804)
,p_name=>'P12_EMIRATE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'Emirate'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'EMIRATES PAGE12'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = 35',
'        and description != :P12_EMP_EMIRATE',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110022089757540805)
,p_name=>'P12_FULL_DAY_YN'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'Full Day ?'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_cHeight=>1
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110022108191540806)
,p_name=>'P12_TRAVEL_ABOVE_10HR_YN'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110022259287540807)
,p_name=>'P12_HOSPITALITY_YN'
,p_is_required=>true
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'Hospitality from other organization?'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if Yes, Hospitality hosted from other organization',
''))
,p_inline_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if Yes, Hospitality hosted from other organization',
''))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110022348822540808)
,p_name=>'P12_START_DATE'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Travel Start Date'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110022462356540809)
,p_name=>'P12_END_DATE'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Travel End Date'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110022529060540810)
,p_name=>'P12_JUSTIFICATION'
,p_is_required=>true
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'Justification'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110022634282540811)
,p_name=>'P12_YEAR'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_item_default=>'select extract(year from sysdate) from dual;'
,p_item_default_type=>'SQL_QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110022704621540812)
,p_name=>'P12_PRIORITY'
,p_is_required=>true
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110022852695540813)
,p_name=>'P12_SEQ'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(max(seq), 0) + 1',
'from mission_header',
'where year = extract(year from sysdate)'))
,p_item_default_type=>'SQL_QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110022959511540814)
,p_name=>'P12_REQUEST_TYPE'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'Request Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'MISSION REQUEST TYPES'
,p_lov=>'.'||wwv_flow_api.id(110033950814469886)||'.'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select Request Type --'
,p_cHeight=>1
,p_display_when=>'P12_REQUEST_ID'
,p_display_when_type=>'ITEM_IS_NULL'
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110137020570737711)
,p_name=>'P12_COUNTRY'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'Country'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'COUNTRIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  SHORT_NAME, CODE , ABOVE_10HR_YN',
'from countries;'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_10=>'ABOVE_10HR_YN:P12_TRAVEL_ABOVE_10HR_YN'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110137130985737712)
,p_name=>'P12_CITY'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(110020617292559145)
,p_prompt=>'City'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(322267768690543)
,p_validation_name=>'Check Mission Dates'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count    number;',
'begin',
'select nvl(count(*), 0)',
'into l_count',
'  from MISSION_HEADER',
'  where REQUEST_FOR = :P12_REQUEST_FOR',
'  and request_id != nvl(:P12_REQUEST_ID,-1)',
'  and (:P12_START_DATE between  start_date and END_DATE',
'  OR :P12_END_DATE between  start_date and END_DATE)',
';',
'',
'if l_count > 0    Then return false;',
'end if;',
'end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'There are Duty request during &P12_START_DATE. and &P12_END_DATE. You can check it in the previous request region.'
,p_associated_item=>wwv_flow_api.id(110022348822540808)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
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
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(1410766854226336)
,p_validation_name=>'Check Bank Account'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select user_details.payroll_area_vendor_IBAN(user_details.get_payroll_area_by_personID(:P12_REQUEST_FOR),:P12_REQUEST_FOR ) iban',
'from dual;'))
,p_validation_type=>'EXISTS'
,p_error_message=>'There is no Bank account defined for the requestor, Please contact ER Team.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(4994539242410325)
,p_validation_name=>'Check Cost Center for the requestor'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if user_details.get_cost_center(:P12_REQUEST_FOR) is null',
'    Then return false;',
'    End if;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'The requestor cost Center not defined, Please contact FInance Team.'
,p_associated_item=>wwv_flow_api.id(110021740007540802)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(110023559739540820)
,p_name=>'Overseas DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_OVERSEAS_YN'
,p_condition_element=>'P12_OVERSEAS_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110023662286540821)
,p_event_id=>wwv_flow_api.id(110023559739540820)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_COUNTRY,P12_CITY'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110023794230540822)
,p_event_id=>wwv_flow_api.id(110023559739540820)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_COUNTRY,P12_CITY'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110105931897864250)
,p_event_id=>wwv_flow_api.id(110023559739540820)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_FULL_DAY_YN,P12_EMIRATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110136074901737701)
,p_event_id=>wwv_flow_api.id(110023559739540820)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_TRAVEL_ABOVE_10HR_YN,P12_HOSPITALITY_YN,P12_COUNTRY,P12_CITY'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(110105606088864247)
,p_name=>'Cancel DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(110105511151864246)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110105759804864248)
,p_event_id=>wwv_flow_api.id(110105606088864247)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(321057433690531)
,p_name=>'Full Day DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_FULL_DAY_YN'
,p_condition_element=>'P12_FULL_DAY_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(321205988690532)
,p_event_id=>wwv_flow_api.id(321057433690531)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_HOSPITALITY_YN,P12_END_DATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(321402766690534)
,p_event_id=>wwv_flow_api.id(321057433690531)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_HOSPITALITY_YN,P12_END_DATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(321296904690533)
,p_event_id=>wwv_flow_api.id(321057433690531)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_HOSPITALITY_YN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1027028599809137)
,p_name=>'Previous request Refresh DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_REQUEST_FOR,P12_START_DATE,P12_END_DATE'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'!apex.item("P12_REQUEST_FOR").isEmpty() &&',
'    !apex.item("P12_START_DATE").isEmpty() &&',
'    !apex.item("P12_END_DATE").isEmpty() '))
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1027180965809138)
,p_event_id=>wwv_flow_api.id(1027028599809137)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(322486811690545)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1414444980226373)
,p_name=>'Requestor Changes DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_REQUEST_FOR'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1849555004296324)
,p_event_id=>wwv_flow_api.id(1414444980226373)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_NOT_CONFIRMED,P12_ELIGIBALE_TO_REQUEST'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(count(*),0) , user_details.check_mission_eligible_by_personId(:P12_REQUEST_FOR , :P12_REQUEST_ID)',
'from mission_header mh',
'where request_status != ''Cancelled''  --''Approved'' ',
'and (COMPLETE_STATUS != ''Confirmed'' or COMPLETE_STATUS is null)',
'and mh.REQUEST_FOR = :P12_REQUEST_FOR',
'and mh.request_id != nvl(:P12_REQUEST_ID , -1)',
';'))
,p_attribute_07=>'P12_REQUEST_FOR'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_da_action_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'',
'/*',
'and not EXISTS (Select  1       --me.PERSON_ID ',
'                        from MISSION_EXCEPTIONS me',
'                        where me.STATUS = ''A''',
'                        and me.person_id = mh.REQUEST_FOR',
'                        and sysdate between nvl(START_DATE, sysdate - 10) and',
'                                            nvl(END_DATE, sysdate + 10));',
'*/                                            '))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1849898948296327)
,p_name=>'Not Confirmed DA'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_NOT_CONFIRMED'
,p_condition_element=>'P12_NOT_CONFIRMED'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'0'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1850158569296330)
,p_event_id=>wwv_flow_api.id(1849898948296327)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_EMP_EMIRATE,P12_OVERSEAS_YN,P12_TRAVEL_ABOVE_10HR_YN,P12_HOSPITALITY_YN,P12_START_DATE,P12_END_DATE,P12_JUSTIFICATION,P12_PRIORITY'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1850849293296337)
,p_event_id=>wwv_flow_api.id(1849898948296327)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(110023443301540819)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1850773245296336)
,p_event_id=>wwv_flow_api.id(1849898948296327)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(110023236456540817)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1850342807296332)
,p_event_id=>wwv_flow_api.id(1849898948296327)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(322342240690544)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1850664331296335)
,p_event_id=>wwv_flow_api.id(1849898948296327)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(322342240690544)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1850243071296331)
,p_event_id=>wwv_flow_api.id(1849898948296327)
,p_event_result=>'FALSE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_EMP_EMIRATE,P12_OVERSEAS_YN,P12_TRAVEL_ABOVE_10HR_YN,P12_HOSPITALITY_YN,P12_START_DATE,P12_END_DATE,P12_JUSTIFICATION,P12_PRIORITY'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1850440495296333)
,p_event_id=>wwv_flow_api.id(1849898948296327)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(110023236456540817)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1850561445296334)
,p_event_id=>wwv_flow_api.id(1849898948296327)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(110023443301540819)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4164574380042827)
,p_name=>'ELIGIBALE_TO_REQUEST DA'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_ELIGIBALE_TO_REQUEST'
,p_condition_element=>'P12_ELIGIBALE_TO_REQUEST'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4165693725042838)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(322342240690544)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4995834762410338)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1849644088296325)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4165267526042834)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(4165077316042832)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4165588021042837)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_EMP_EMIRATE,P12_OVERSEAS_YN,P12_TRAVEL_ABOVE_10HR_YN,P12_HOSPITALITY_YN,P12_START_DATE,P12_END_DATE,P12_JUSTIFICATION,P12_PRIORITY'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4164705028042828)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(110023236456540817)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4165393693042835)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_EMP_EMIRATE,P12_OVERSEAS_YN,P12_TRAVEL_ABOVE_10HR_YN,P12_HOSPITALITY_YN,P12_START_DATE,P12_END_DATE,P12_JUSTIFICATION,P12_PRIORITY'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4164753565042829)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(110023443301540819)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4165446851042836)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(322342240690544)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4164935531042831)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'FALSE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(110023443301540819)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4165182817042833)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(4165077316042832)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4164855818042830)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'FALSE'
,p_action_sequence=>60
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(110023236456540817)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4995799511410337)
,p_event_id=>wwv_flow_api.id(4164574380042827)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1849644088296325)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4996759332410347)
,p_name=>'Emirate Display DA'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_OVERSEAS_YN'
,p_condition_element=>'P12_OVERSEAS_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4996868663410348)
,p_event_id=>wwv_flow_api.id(4996759332410347)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_EMIRATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4996945351410349)
,p_event_id=>wwv_flow_api.id(4996759332410347)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_EMIRATE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(110105405096864245)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize Mission Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  REQUEST_ID,',
'        REQUEST_TYPE,',
'        REQUEST_NO,',
'        to_char(REQUEST_DATE, ''dd-Mon-yyyy'') REQUEST_DATE,',
'        REQUEST_FOR,',
'        OVERSEAS_YN,',
'        EMIRATE,',
'        FULL_DAY_YN,',
'        TRAVEL_ABOVE_10HR_YN,',
'        HOSPITALITY_YN,',
'        START_DATE,',
'        END_DATE,',
'        JUSTIFICATION,',
'        YEAR,',
'        SEQ,',
'        PRIORITY',
'into    ',
'        :P12_REQUEST_ID,',
'        :P12_REQUEST_TYPE,',
'        :P12_REQUEST_NO,',
'        :P12_REQUEST_DATE,',
'        :P12_REQUEST_FOR,',
'        :P12_OVERSEAS_YN,',
'        :P12_EMIRATE,',
'        :P12_FULL_DAY_YN,',
'        :P12_TRAVEL_ABOVE_10HR_YN,',
'        :P12_HOSPITALITY_YN,',
'        :P12_START_DATE,',
'        :P12_END_DATE,',
'        :P12_JUSTIFICATION,',
'        :P12_YEAR,',
'        :P12_SEQ,',
'        :P12_PRIORITY',
'from MISSION_HEADER   ',
'where request_id = :P12_REQUEST_ID;',
'',
'select country, city',
'into :P12_COUNTRY , :P12_CITY',
'from mission_legs',
'where request_id = :P12_REQUEST_ID',
'and seq = 1;',
'',
'exception',
'    when others then null;     '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P12_REQUEST_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(110023113255540816)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert New Reuest'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_type              varchar2(1);',
'l_total_count       number;',
'l_request_no        varchar2(50);',
'l_grade            varchar2(50);',
'l_count            Number;',
'BEGIN',
'',
'l_grade := user_details.get_emp_grade(:P12_REQUEST_FOR , ''id'');',
'IF l_grade  is  null  ',
'            Then ',
'    ',
'                    apex_error.add_error (p_message  => ''The grade for the selected requestor not defined. Please contact Employee Relation Team''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif);',
'                                            ',
'     elsif   TO_DATE(:P12_START_DATE,''DD.MM.YY'') > TO_DATE(:P12_END_DATE,''DD.MM.YY'') ',
'            THEN',
'                    apex_error.add_error (p_message => ''Mission End Date can not be before Start Date''  ,',
'                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif);',
'                                                                                                                        ',
'        else',
'        ',
'    -- get total Count By Year',
'        select nvl(max(SEQ),0) + 1',
'        into l_total_count',
'        from MISSION_HEADER',
'        where year = EXTRACT(year from sysdate);',
'    ',
'l_request_no := :P12_REQUEST_TYPE ',
'                || to_char(sysdate, ''yyyymmdd'') || ''/'' ',
'                || user_details.get_username(:P12_REQUEST_FOR)  || ''/''   ',
'                || :P12_REQUEST_TYPE              ||',
'                   to_char(l_total_count);',
'                   ',
' SELECT MISSION_HEADER_SEQ.nextval',
'into :P12_REQUEST_ID',
'FROM all_sequences',
' WHERE sequence_owner = ''PROD''',
'   AND sequence_name = ''MISSION_HEADER_SEQ'';',
'   ',
'   INSERT INTO MISSION_HEADER (',
'                                REQUEST_ID,',
'                                REQUEST_TYPE,',
'                                REQUEST_NO,',
'                                REQUEST_DATE,',
'                                REQUEST_FOR,',
'                                OVERSEAS_YN,',
'                                EMIRATE,',
'                                FULL_DAY_YN,',
'                                TRAVEL_ABOVE_10HR_YN,',
'                                HOSPITALITY_YN,',
'                                START_DATE,',
'                                END_DATE,',
'                                JUSTIFICATION,',
'                                YEAR,',
'                                SEQ,',
'                                PRIORITY,',
'                                GRADE_CODE,',
'                                GRADE_RATE,',
'                                request_status,',
'                                COST_CENTER,',
'                                PAY_ALONE,',
'                                CREATE_PV_AFTER_CONFIRM,',
'                                PAYMENT_METHOD,',
'                                INVOICE_TYPE,',
'                                SUPPLIER_NAME,',
'                                SITE_NAME,',
'                                CURRENCY,',
'                                PAY_GROUP,',
'                                PAYMENT_TERM,',
'                                HEADER_CONTEXT,',
'                               HASH_CODE',
'                                ',
') VALUES (',
'    :P12_REQUEST_ID,',
'    :P12_REQUEST_TYPE,',
'    l_request_no,',
'    sysdate,',
'    :P12_REQUEST_FOR,',
'    :P12_OVERSEAS_YN,',
'    :P12_EMIRATE,',
'    :P12_FULL_DAY_YN,',
'    :P12_TRAVEL_ABOVE_10HR_YN,',
'    :P12_HOSPITALITY_YN,',
'    to_date(:P12_START_DATE , ''DD-MON-YYYY''),',
'    case :P12_FULL_DAY_YN when ''N'' Then to_date(:P12_START_DATE , ''DD-MON-YYYY'')',
'            else to_date(:P12_END_DATE , ''DD-MON-YYYY'')',
'       End     ,',
'    :P12_JUSTIFICATION,',
'    EXTRACT(year from sysdate),',
'    :P12_SEQ,',
'    :P12_PRIORITY,',
'    l_grade,',
'    mission_util.get_mission_rate(user_details.get_emp_grade(:P12_REQUEST_FOR , ''id'') , :P12_OVERSEAS_YN),',
'    ''Draft'',',
'    user_details.get_cost_center(:P12_REQUEST_FOR),',
'    MISSION_UTIL.PAY_ALONE(''APDT''),',
'    MISSION_UTIL.CREATE_PV_AFTER_CONFIRM(''APDT''),',
'    MISSION_UTIL.payment_method(''APDT''),',
'    MISSION_UTIL.invoice_type(''APDT''),',
'    ',
'    MISSION_UTIL.def_supplier_name(''APDT''),',
'    MISSION_UTIL.site_name(''APDT''),',
'    MISSION_UTIL.currency(''APDT''),',
'    MISSION_UTIL.pay_group(''APDT''),',
'    MISSION_UTIL.payment_term(''APDT''),',
'    MISSION_UTIL.HEADER_CONTEXT(''APDT''),',
'    apex_util.get_hash(apex_t_varchar2(:P12_REQUEST_ID ))',
');',
'',
'',
'INSERT INTO mission_legs (',
'    request_id,',
'    seq,',
'    country,',
'    city,',
'    no_of_days,',
'    start_date,',
'    end_date',
') VALUES (',
'    :P12_REQUEST_ID,',
'    1,',
'    :P12_COUNTRY,',
'    :P12_CITY,',
'    (to_date(:P12_END_DATE , ''DD-MON-YYYY'') - to_date(:P12_START_DATE , ''DD-MON-YYYY''))+ 1,',
'    to_date(:P12_START_DATE , ''DD-MON-YYYY''),',
'    to_date(:P12_END_DATE , ''DD-MON-YYYY'')',
');',
'',
'End if;',
'',
'End;',
'   '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(110023236456540817)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(110105842355864249)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Header'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count            Number;',
'l_grade            varchar2(50);',
'BEGIN',
'',
'l_grade := user_details.get_emp_grade(:P12_REQUEST_FOR , ''id'');',
'IF l_grade  is  null  ',
'            Then ',
'    ',
'                    apex_error.add_error (p_message  => ''The grade for the selected requestor not defined. Please contact Employee Relation Team''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif);',
'',
'Elsif TO_DATE(:P12_START_DATE,''DD.MM.YY'') > TO_DATE(:P12_END_DATE,''DD.MM.YY'') ',
'    THEN',
'       apex_error.add_error ( p_message          => ''Mission End Date can not be before Start Date''  ,',
'                              p_display_location =>  apex_error.c_inline_with_field_and_notif);',
'    ',
'else',
'',
'    update MISSION_HEADER',
'    set     request_for = :p12_REQUEST_FOR,',
'            OVERSEAS_YN = :P12_OVERSEAS_YN,',
'            GRADE_CODE = l_grade,',
'            GRADE_RATE  = mission_util.get_mission_rate(user_details.get_emp_grade(:P12_REQUEST_FOR , ''id'') , :P12_OVERSEAS_YN),',
'            EMIRATE = :P12_EMIRATE,',
'            FULL_DAY_YN = :P12_FULL_DAY_YN,',
'            TRAVEL_ABOVE_10HR_YN = :P12_TRAVEL_ABOVE_10HR_YN,',
'            HOSPITALITY_YN = :P12_HOSPITALITY_YN,',
'            START_DATE = to_date(:P12_START_DATE , ''DD-MON-YYYY''),',
'            END_DATE =     case :P12_FULL_DAY_YN when ''N'' Then to_date(:P12_START_DATE , ''DD-MON-YYYY'')',
'                else to_date(:P12_END_DATE , ''DD-MON-YYYY'')',
'           End ,',
'            JUSTIFICATION = :P12_JUSTIFICATION,',
'            PRIORITY =:P12_PRIORITY,',
'            COST_CENTER = user_details.get_cost_center(:P12_REQUEST_FOR)',
'    where request_id = :P12_REQUEST_ID;',
'    ',
'    ',
'     update  mission_legs set',
'    country = :P12_COUNTRY,',
'    city    = :P12_CITY,',
'    no_of_days = (to_date(:P12_END_DATE , ''DD-MON-YYYY'') - to_date(:P12_START_DATE , ''DD-MON-YYYY''))+ 1,',
'    start_date = to_date(:P12_START_DATE , ''DD-MON-YYYY''),',
'    end_date   = to_date(:P12_END_DATE , ''DD-MON-YYYY'')',
'where request_id = :P13_REQUEST_ID',
'and   seq = 1;',
'',
'end if;',
'End;'))
,p_process_error_message=>'Not Updated, Please Contact the system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(110023443301540819)
,p_process_success_message=>'Updated Successfully.'
);
wwv_flow_api.component_end;
end;
/
