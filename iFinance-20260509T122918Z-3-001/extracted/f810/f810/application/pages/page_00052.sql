prompt --application/pages/page_00052
begin
--   Manifest
--     PAGE: 00052
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
 p_id=>52
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Payroll Dashboard'
,p_alias=>'PAYROLL-DASHBOARD'
,p_step_title=>'Payroll Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240205091105'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(85708852232488657)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple'
,p_plug_template=>wwv_flow_api.id(12905503889762115)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(85709191818488660)
,p_plug_name=>'History'
,p_parent_plug_id=>wwv_flow_api.id(85708852232488657)
,p_icon_css_classes=>'fa-list-ul'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
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
'       nvl(EXECUTED_STATUS , ''NA'') executed_status_h,',
'       mh.EXECUTED_BY,',
'       mh.EXECUTED_ON,',
'        MISSION_UTIL.get_project_no(mh.REQUEST_ID) project_number,',
'       MISSION_UTIL.get_fbp(mh.REQUEST_ID)          fbp_name,',
'       Case REQUEST_STATUS when ''Approved''',
'       Then',
'               case mh.EXECUTED_STATUS',
'                    when  ''Y'' ',
'                            Then ',
'                                ''<span class="fa fa-check-circle" style="color:green"></span>''',
'                            else ',
'                               ''<span class="fa fa-check-circle" style="color:red"></span>'' ',
'               end    ',
'        End executed_status   ',
'',
'  from MISSION_HEADER mh, employees_v e',
'  where mh.request_for = e.person_id',
'  and (mh.CAR_REQUEST_YN = ''P'' or mh.CAR_REQUEST_YN is null)',
'  and mh.EXECUTED_STATUS = ''Y''',
'--    and REQUEST_TYPE = :P3_TYPE_CODE',
'-- and ou_code = :OU_CODE   ',
'    and mh.REQUEST_STATUS = ''Approved'';'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'History'
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
 p_id=>wwv_flow_api.id(85709320995488661)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>196320197485495638
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85709360361488662)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85709433152488663)
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
 p_id=>wwv_flow_api.id(85709580654488664)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85709644187488665)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85709812304488666)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85709911912488667)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85709930534488668)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85710110136488669)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85710219131488670)
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
 p_id=>wwv_flow_api.id(85710239198488671)
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
 p_id=>wwv_flow_api.id(85710342398488672)
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
 p_id=>wwv_flow_api.id(85710498009488673)
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
 p_id=>wwv_flow_api.id(91717015537528324)
,p_db_column_name=>'AMOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91717039859528325)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91717194149528326)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91717288037528327)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_REQUEST_ID,REQUEST_ID,P13_PAGE_FROM:#REQUEST_ID#,#REQUEST_ID#,52'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91717331499528328)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'PV Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91717484059528329)
,p_db_column_name=>'EXECUTED_STATUS'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Executed Status'
,p_column_link=>'f?p=&APP_ID.:53:&SESSION.::&DEBUG.:53:P53_REQUEST_ID,P53_REQUEST_NUMBER,P53_REQUEST_STATUS:#REQUEST_ID#,#REQUEST_NO#,#EXECUTED_STATUS_H#'
,p_column_linktext=>'#EXECUTED_STATUS#'
,p_allow_sorting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91717595351528330)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91717681200528331)
,p_db_column_name=>'SECTOR'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91717755540528332)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91717857884528333)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91717928888528434)
,p_db_column_name=>'EXECUTED_STATUS_H'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Executed Status H'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91718096371528435)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91718194850528436)
,p_db_column_name=>'REQUEST_FOR'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Request For'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91718268401528437)
,p_db_column_name=>'GRADE_CODE'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Grade Code'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109823118131928448)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91718408012528438)
,p_db_column_name=>'GRADE_RATE'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Grade Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91718447703528439)
,p_db_column_name=>'OVERSEAS_YN'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Overseas Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91718524810528440)
,p_db_column_name=>'EMIRATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Emirate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91718690354528441)
,p_db_column_name=>'FULL_DAY_YN'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Full Day Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91718745066528442)
,p_db_column_name=>'TRAVEL_ABOVE_10HR_YN'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Travel Above 10hr Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91718922301528443)
,p_db_column_name=>'TICKET_REQUEST'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Ticket Request'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91718956860528444)
,p_db_column_name=>'HOSPITALITY_YN'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Hospitality Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91719044279528445)
,p_db_column_name=>'TRANSPORTATION'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Transportation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91719154788528446)
,p_db_column_name=>'START_DATE'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91719290493528447)
,p_db_column_name=>'END_DATE'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91719343218528448)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Request Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91719478127528449)
,p_db_column_name=>'COMPLETE_STATUS'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Complete Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91719563683528450)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91719627767528451)
,p_db_column_name=>'YEAR'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91719773453528452)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Purpose Eu'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91719871015528453)
,p_db_column_name=>'PRIORITY'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91719942297528454)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91720023901528455)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91720223283528456)
,p_db_column_name=>'SEQ'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91720276399528457)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91720391603528458)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(110033950814469886)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91720440078528459)
,p_db_column_name=>'EXECUTED_BY'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Executed By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91720550986528460)
,p_db_column_name=>'EXECUTED_ON'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Executed On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114994535915528731)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Project '
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114994716295528732)
,p_db_column_name=>'FBP_NAME'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Finance BP'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(91738780757552702)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2023497'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_FOR:EMPLOYEE_NUM:AMOUNT:COST_CENTER:PV_NUMBER:PROJECT_NUMBER:FBP_NAME:EXECUTED_STATUS:EXECUTED_BY:EXECUTED_ON:'
,p_sort_column_1=>'EXECUTED_ON'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(91211721563343203)
,p_plug_name=>'Payroll Worklist'
,p_parent_plug_id=>wwv_flow_api.id(85708852232488657)
,p_icon_css_classes=>'fa-list-ul'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
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
'       mh.invoice_number,',
'        MISSION_UTIL.get_project_no(mh.REQUEST_ID) project_number,',
'       MISSION_UTIL.get_fbp(mh.REQUEST_ID)          fbp_name,',
'       mh.payroll_area_id    payroll_area,',
'       nvl(EXECUTED_STATUS , ''NA'') executed_status_h,',
'       Case REQUEST_STATUS when ''Approved''',
'       Then',
'               case mh.EXECUTED_STATUS',
'                    when  ''Y'' ',
'                            Then ',
'                                ''<span class="fa fa-check-circle" style="color:green"></span>''',
'                            else ',
'                               ''<span class="fa fa-check-circle" style="color:red"></span>'' ',
'               end    ',
'        End executed_status   ',
'',
'  from MISSION_HEADER mh, employees_v e',
'  where mh.request_for = e.person_id',
'  and (mh.CAR_REQUEST_YN = ''P'' or mh.CAR_REQUEST_YN is null)',
'--    and REQUEST_TYPE = :P3_TYPE_CODE',
'-- and ou_code = :OU_CODE   ',
'    and mh.REQUEST_STATUS = ''Approved'';'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payroll Worklist'
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
 p_id=>wwv_flow_api.id(84399927115618550)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>195010803605625527
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84400024767618551)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84400196892618552)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_REQUEST_ID,REQUEST_ID,P13_PAGE_FROM:#REQUEST_ID#,#REQUEST_ID#,52'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84400318120618553)
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
 p_id=>wwv_flow_api.id(84400390193618554)
,p_db_column_name=>'REQUEST_FOR'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Request For'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84400491950618555)
,p_db_column_name=>'GRADE_CODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Grade Code'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109823118131928448)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84400604323618556)
,p_db_column_name=>'GRADE_RATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Grade Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84400649860618557)
,p_db_column_name=>'OVERSEAS_YN'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Overseas Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84400732444618558)
,p_db_column_name=>'EMIRATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Emirate'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109829266094654960)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84400876904618559)
,p_db_column_name=>'FULL_DAY_YN'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Full Day Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84401005633618560)
,p_db_column_name=>'TRAVEL_ABOVE_10HR_YN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Travel Above 10hr Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84401123092618561)
,p_db_column_name=>'TICKET_REQUEST'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Ticket Request'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84401155368618562)
,p_db_column_name=>'HOSPITALITY_YN'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Hospitality Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84401271417618563)
,p_db_column_name=>'TRANSPORTATION'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Transportation'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84401377616618564)
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
 p_id=>wwv_flow_api.id(84401447403618565)
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
 p_id=>wwv_flow_api.id(84401562316618566)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Request Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84401683185618567)
,p_db_column_name=>'COMPLETE_STATUS'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Complete Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84401731807618568)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84402164162618572)
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
 p_id=>wwv_flow_api.id(84402314493618573)
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
 p_id=>wwv_flow_api.id(91219143401348725)
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
 p_id=>wwv_flow_api.id(91219302643348726)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91219343547348727)
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
 p_id=>wwv_flow_api.id(91220075156348734)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
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
 p_id=>wwv_flow_api.id(91220214893348735)
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
 p_id=>wwv_flow_api.id(91220238148348736)
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
 p_id=>wwv_flow_api.id(91220420606348737)
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
 p_id=>wwv_flow_api.id(91220493067348738)
,p_db_column_name=>'AMOUNT'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91220658775348740)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91222231503348756)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'PV Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85708309770488651)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85708341868488652)
,p_db_column_name=>'SECTOR'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85708461100488653)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85708562145488654)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85707945668488648)
,p_db_column_name=>'EXECUTED_STATUS'
,p_display_order=>620
,p_column_identifier=>'BE'
,p_column_label=>'Executed Status'
,p_column_link=>'f?p=&APP_ID.:53:&SESSION.::&DEBUG.:53:P53_REQUEST_ID,P53_REQUEST_NUMBER,P53_REQUEST_STATUS:#REQUEST_ID#,#REQUEST_NO#,#EXECUTED_STATUS_H#'
,p_column_linktext=>'#EXECUTED_STATUS#'
,p_allow_sorting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84402071235618571)
,p_db_column_name=>'PRIORITY'
,p_display_order=>630
,p_column_identifier=>'U'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84401862606618569)
,p_db_column_name=>'YEAR'
,p_display_order=>640
,p_column_identifier=>'S'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84401963726618570)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>650
,p_column_identifier=>'T'
,p_column_label=>'Purpose Eu'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91219061419348724)
,p_db_column_name=>'SEQ'
,p_display_order=>660
,p_column_identifier=>'X'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91219436876348728)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>670
,p_column_identifier=>'AB'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91219601500348729)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>680
,p_column_identifier=>'AC'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91219626946348730)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>690
,p_column_identifier=>'AD'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91219786801348731)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>700
,p_column_identifier=>'AE'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91219913071348732)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>710
,p_column_identifier=>'AF'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91219971986348733)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>720
,p_column_identifier=>'AG'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91220606486348739)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>730
,p_column_identifier=>'AM'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85708644919488655)
,p_db_column_name=>'EXECUTED_STATUS_H'
,p_display_order=>740
,p_column_identifier=>'BJ'
,p_column_label=>'Executed Status H'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(98091884680572543)
,p_db_column_name=>'PAYROLL_AREA'
,p_display_order=>750
,p_column_identifier=>'BK'
,p_column_label=>'Payroll Area'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(78777153798461677)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(107261381574706634)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>760
,p_column_identifier=>'BL'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114994822890528733)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>770
,p_column_identifier=>'BM'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114994849871528734)
,p_db_column_name=>'FBP_NAME'
,p_display_order=>780
,p_column_identifier=>'BN'
,p_column_label=>'Finance BP'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(91646803213714500)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2022577'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:EMPLOYEE_NUM:REQUEST_FOR:PAYROLL_AREA:AMOUNT:COST_CENTER:REQUEST_STATUS:PV_NUMBER:PROJECT_NUMBER:FBP_NAME:EXECUTED_STATUS:INVOICE_NUMBER:'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(98834784277034272)
,p_application_user=>'TCA9051'
,p_name=>'Direct Hire without PV'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NO:EMPLOYEE_NUM:REQUEST_FOR:PAYROLL_AREA:AMOUNT:COST_CENTER:REQUEST_STATUS:PV_NUMBER:EXECUTED_STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(98834871818034272)
,p_report_id=>wwv_flow_api.id(98834784277034272)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'PAYROLL_AREA'
,p_operator=>'in'
,p_expr=>'DCT Payroll,LAD direct Hires'
,p_condition_sql=>'"PAYROLL_AREA" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''DCT Payroll, LAD direct Hires''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(98834940827034272)
,p_report_id=>wwv_flow_api.id(98834784277034272)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'PV_NUMBER'
,p_operator=>'is null'
,p_condition_sql=>'"PV_NUMBER" is null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(98841573729059251)
,p_application_user=>'TCA9051'
,p_name=>'Direct Hire without PV- Details'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NO:EMPLOYEE_NUM:REQUEST_FOR:JUSTIFICATION:START_DATE:END_DATE:PAYROLL_AREA:AMOUNT:COST_CENTER:REQUEST_STATUS:PV_NUMBER:EXECUTED_STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(98841627027059251)
,p_report_id=>wwv_flow_api.id(98841573729059251)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'PAYROLL_AREA'
,p_operator=>'in'
,p_expr=>'DCT Payroll,LAD direct Hires'
,p_condition_sql=>'"PAYROLL_AREA" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''DCT Payroll, LAD direct Hires''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(98841735784059251)
,p_report_id=>wwv_flow_api.id(98841573729059251)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'PV_NUMBER'
,p_operator=>'is null'
,p_condition_sql=>'"PV_NUMBER" is null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(91204207330343196)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(91207511845343201)
,p_plug_name=>'Duty Travel Execution'
,p_icon_css_classes=>'fa-file-text'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(91207908081343202)
,p_region_id=>wwv_flow_api.id(91207511845343201)
,p_chart_type=>'donut'
,p_height=>'350'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_position=>'end'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(91208400815343202)
,p_chart_id=>wwv_flow_api.id(91207908081343202)
,p_seq=>10
,p_name=>'Series 1'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXECUTED_STATUS',
'    , TOTAL_COUNT',
'    , AMOUNT    AMOUNT_h',
'    , trim(to_Char(AMOUNT,''99,999,999,999.99'')) AMOUNT',
'    , case EXECUTED_STATUS ',
'                    when ''Initiated''     then ''green''',
'                    when ''Pending''       then ''red''',
'    end color',
'from(',
'select decode(mh.EXECUTED_STATUS,''Y'' , ''Initiated'' , ''Pending'') EXECUTED_STATUS,',
'        count(mh.REQUEST_ID) total_count,',
'       sum(MISSION_UTIL.get_mission_amount(mh.REQUEST_ID))    AMOUNT',
'  from MISSION_HEADER mh, employees_v e',
'  where mh.request_for = e.person_id',
'  and (mh.CAR_REQUEST_YN = ''P'' or mh.CAR_REQUEST_YN is null)',
'  and mh.request_status = ''Approved''',
'group by mh.EXECUTED_STATUS)',
'order by AMOUNT_h desc;'))
,p_max_row_count=>20
,p_items_value_column_name=>'TOTAL_COUNT'
,p_items_label_column_name=>'EXECUTED_STATUS'
,p_items_short_desc_column_name=>'AMOUNT'
,p_color=>'&COLOR.'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideSlice'
,p_items_label_display_as=>'ALL'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(91209010187343202)
,p_plug_name=>'Duty Travel Requests By Status'
,p_icon_css_classes=>'fa-plane'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(91209385994343202)
,p_region_id=>wwv_flow_api.id(91209010187343202)
,p_chart_type=>'bar'
,p_title=>'Count: &P52_COUNT., (Amount:  &P52_AMOUNT. AED)'
,p_height=>'350'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_fill_multi_series_gaps=>false
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(91211110266343203)
,p_chart_id=>wwv_flow_api.id(91209385994343202)
,p_seq=>10
,p_name=>'Series 1'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select REQUEST_STATUS',
'    , TOTAL_COUNT',
'    , AMOUNT    AMOUNT_h',
'    , trim(to_Char(AMOUNT,''99,999,999,999.99'')) AMOUNT',
'    , case REQUEST_STATUS ',
'                    when ''Approved''     then ''green''',
'                    when ''Rejected''     then ''red''',
'                    when ''in-Progress''  then ''#5ED8EE''',
'                    when ''Withdraw''     then ''blue''',
'                    when ''Draft''        then ''gray''',
'                    else ''#F8F041''',
'    end color',
'from(',
'select mh.REQUEST_STATUS,',
'        count(mh.REQUEST_ID) total_count,',
'       sum(MISSION_UTIL.get_mission_amount(mh.REQUEST_ID))    AMOUNT',
'  from MISSION_HEADER mh, employees_v e',
'  where mh.request_for = e.person_id',
'  and (mh.CAR_REQUEST_YN = ''P'' or mh.CAR_REQUEST_YN is null)',
'group by mh.REQUEST_STATUS)',
'order by AMOUNT_h desc;'))
,p_max_row_count=>20
,p_items_value_column_name=>'TOTAL_COUNT'
,p_items_label_column_name=>'REQUEST_STATUS'
,p_items_short_desc_column_name=>'AMOUNT'
,p_color=>'&COLOR.'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideBarEdge'
,p_link_target=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.:54:P54_REQUEST_STATUS:&REQUEST_STATUS.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(91209907495343202)
,p_chart_id=>wwv_flow_api.id(91209385994343202)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(91210456450343203)
,p_chart_id=>wwv_flow_api.id(91209385994343202)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(98092387214572548)
,p_plug_name=>'Duty Travel By Type'
,p_icon_css_classes=>'fa-bar-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody:t-Form--slimPadding'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(98092435315572549)
,p_region_id=>wwv_flow_api.id(98092387214572548)
,p_chart_type=>'donut'
,p_height=>'350'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(98092612531572550)
,p_chart_id=>wwv_flow_api.id(98092435315572549)
,p_seq=>10
,p_name=>'New'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case REQUEST_TYPE',
'        when ''T'' then ''Training''',
'        when ''M'' then ''Mission''',
'        end Request_type ',
'     , TOTAL_COUNT',
'     , AMOUNT',
'     , case REQUEST_TYPE',
'        when ''T'' then ''red''',
'        when ''M'' then ''green''',
'        end color  ',
'from (select request_type,',
'       nvl(count(mh.REQUEST_ID),0) total_count,',
'       nvl(sum(MISSION_UTIL.get_mission_amount(mh.REQUEST_ID)),0)    AMOUNT',
'  from MISSION_HEADER mh, employees_v e',
'  where mh.request_for = e.person_id',
'  and (mh.CAR_REQUEST_YN = ''P'' or mh.CAR_REQUEST_YN is null)',
'group by request_type);'))
,p_items_value_column_name=>'TOTAL_COUNT'
,p_items_label_column_name=>'REQUEST_TYPE'
,p_color=>'&COLOR.'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideSlice'
,p_items_label_display_as=>'ALL'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(98091973205572544)
,p_name=>'P52_COUNT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(91204207330343196)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(98092047882572545)
,p_name=>'P52_AMOUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(91204207330343196)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(98092175104572546)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get total count and amount'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(count(mh.REQUEST_ID),0),''999,999,9999'')) total_count,',
'       trim(to_char(nvl(sum(MISSION_UTIL.get_mission_amount(mh.REQUEST_ID)),0), ''999,999,999.99''))    AMOUNT',
'into :P52_COUNT,',
'     :P52_AMOUNT',
'  from MISSION_HEADER mh, employees_v e',
'  where mh.request_for = e.person_id',
'  and (mh.CAR_REQUEST_YN = ''P'' or mh.CAR_REQUEST_YN is null);'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
