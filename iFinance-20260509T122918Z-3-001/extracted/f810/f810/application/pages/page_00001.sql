prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'Employee Self Service Home'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9234'
,p_last_upd_yyyymmddhh24miss=>'20240301172320'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5906697626981987)
,p_plug_name=>'SSHR List'
,p_component_template_options=>'#DEFAULT#:t-Cards--displaySubtitle:t-Cards--featured force-fa-lg:t-Cards--displayIcons:t-Cards--4cols:t-Cards--iconsRounded:t-Cards--animColorFill'
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(5905716519981988)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12950231628762152)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12994115421762249)
,p_plug_name=>'Apply for your mission or training'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
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
 p_id=>wwv_flow_api.id(93509975428278443)
,p_plug_name=>'All Duty Travel requests - Projects'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':IS_PROJECT_ADMIN_YN = ''Y'' and :PERSON_ID != 680461'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(94792221705956251)
,p_plug_name=>'Missions Reports - Projects'
,p_parent_plug_id=>wwv_flow_api.id(93509975428278443)
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
'       PROJECTS_UTIL.project_name(d.project_number) Project_name,',
'       d.project_number,',
'       d.task_number,',
'       d.expenditure_type,',
'       d.cost_center cost_center_budgeted,',
'       mh.EXECUTED_STATUS initiated',
'  from MISSION_HEADER mh, employees_v e, mission_distributions d',
'  where mh.request_for = e.person_id',
'  and mh.request_id = d.request_id',
'  and (select distinct d.PROJECT_NUMBER ',
'        from mission_distributions d',
'        where d.request_id = mh.request_id) in (select  distinct ENTITY_NAME  project_number',
'                                                    from BTF_DATA_ACCESS_REQUESTS',
'                                                    where person_id = :PERSON_ID',
'                                                    and ENTITY_TYPE = ''PROJECT''',
'                                                    and request_status in (''Auto-Approved'' , ''Approved'')',
'                                                    and sysdate between nvl(start_date , sysdate - 10) ',
'                                                    and nvl(end_date, sysdate + 10));'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Missions Reports - Projects'
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
 p_id=>wwv_flow_api.id(94792246174956252)
,p_max_row_count=>'1000000'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>205403122664963229
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94792382778956253)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94792473779956254)
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
 p_id=>wwv_flow_api.id(94792559239956255)
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
 p_id=>wwv_flow_api.id(94792707975956256)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94792813703956257)
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
 p_id=>wwv_flow_api.id(94792853729956258)
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
 p_id=>wwv_flow_api.id(94792978441956259)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94793035831956260)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94793203585956261)
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
 p_id=>wwv_flow_api.id(94793281952956262)
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
 p_id=>wwv_flow_api.id(94793384653956263)
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
 p_id=>wwv_flow_api.id(94793468598956264)
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
 p_id=>wwv_flow_api.id(94793559951956265)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94793659073956266)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94793808975956267)
,p_db_column_name=>'AMOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94793909515956268)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94793997077956269)
,p_db_column_name=>'SECTOR'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94794077994956270)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94794197187956271)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94794302772956272)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'PV Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94794398015956273)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::P13_REQUEST_ID,REQUEST_ID,P13_PAGE_FROM:#REQUEST_ID#,#REQUEST_ID#,1'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95283675037365024)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95283823047365025)
,p_db_column_name=>'REQUEST_FOR'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95283867976365026)
,p_db_column_name=>'GRADE_CODE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Grade'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109823118131928448)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95283962245365027)
,p_db_column_name=>'GRADE_RATE'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Grade Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95284061423365028)
,p_db_column_name=>'OVERSEAS_YN'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Overseas ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95284159973365029)
,p_db_column_name=>'EMIRATE'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Emirate'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109829266094654960)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95284262433365030)
,p_db_column_name=>'FULL_DAY_YN'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Full Day ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95284375025365031)
,p_db_column_name=>'TRAVEL_ABOVE_10HR_YN'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Travel Above 10hr ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95284424444365032)
,p_db_column_name=>'TICKET_REQUEST'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Ticket Request'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109829432214610256)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95284543618365033)
,p_db_column_name=>'HOSPITALITY_YN'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Hospitality ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95284699542365034)
,p_db_column_name=>'TRANSPORTATION'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Transportation'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109830333459518310)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95284810381365035)
,p_db_column_name=>'START_DATE'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95284913296365036)
,p_db_column_name=>'END_DATE'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95284993499365037)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Request Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95285061054365038)
,p_db_column_name=>'COMPLETE_STATUS'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Confirmation Status'
,p_column_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23:P23_CONFIRMED_STATUS,P23_REQUEST_ID,P23_REQUEST_NUMBER:#COMPLETE_STATUS#,#REQUEST_ID#,#REQUEST_NO#'
,p_column_linktext=>'#COMPLETE_STATUS#'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95285144540365039)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95285236230365040)
,p_db_column_name=>'YEAR'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95285342908365041)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Purpose'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95285424890365042)
,p_db_column_name=>'PRIORITY'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109815946584935965)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95285545429365043)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95285645330365044)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95285732458365045)
,p_db_column_name=>'SEQ'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95285918359365046)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95285989987365047)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(110033950814469886)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95286115529365048)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95286143453365049)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95286317669365050)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95286400396365051)
,p_db_column_name=>'COST_CENTER_BUDGETED'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(85480431739639784)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95286509287365052)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(98092839404572553)
,p_db_column_name=>'INITIATED'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Initiated'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109820486212935961)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(95303821113412722)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2059147'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_FOR:EMPLOYEE_NUM:REQUEST_DATE:COST_CENTER_BUDGETED:AMOUNT:PV_NUMBER:OVERSEAS_YN:START_DATE:END_DATE:PROJECT_NUMBER:COMPLETE_STATUS:REQUEST_STATUS::INITIATED'
,p_sort_column_1=>'FINAL_APPROVE_ON'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(100095926061505270)
,p_application_user=>'TCA154'
,p_name=>'IH - BUDGET'
,p_report_seq=>10
,p_display_rows=>100000
,p_report_columns=>'REQUEST_NO:REQUEST_FOR:EMPLOYEE_NUM:REQUEST_DATE:COST_CENTER_BUDGETED:AMOUNT:PV_NUMBER:INITIATED:START_DATE:END_DATE:PROJECT_NUMBER:COMPLETE_STATUS:REQUEST_STATUS'
,p_sort_column_1=>'FINAL_APPROVE_ON'
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
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(100096120812505271)
,p_report_id=>wwv_flow_api.id(100095926061505270)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'COST_CENTER_BUDGETED'
,p_operator=>'contains'
,p_expr=>'4511600'
,p_condition_sql=>'upper("COST_CENTER_BUDGETED") like ''%''||upper(#APXWS_EXPR#)||''%'''
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''4511600''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(116873752368081344)
,p_application_user=>'TCA154'
,p_name=>'Historical report'
,p_report_seq=>10
,p_display_rows=>100000
,p_report_columns=>'REQUEST_NO:REQUEST_FOR:EMPLOYEE_NUM:REQUEST_DATE:COST_CENTER_BUDGETED:AMOUNT:PV_NUMBER:OVERSEAS_YN:START_DATE:END_DATE:PROJECT_NUMBER:COMPLETE_STATUS:REQUEST_STATUS::INITIATED'
,p_sort_column_1=>'FINAL_APPROVE_ON'
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
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(116873872487081345)
,p_report_id=>wwv_flow_api.id(116873752368081344)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'COST_CENTER_BUDGETED'
,p_operator=>'='
,p_expr=>'(4511300) DCT - Historical Environment Dept'
,p_condition_sql=>'"COST_CENTER_BUDGETED" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''(4511300) DCT - Historical Environment Dept''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(116873930384081345)
,p_report_id=>wwv_flow_api.id(116873752368081344)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'INITIATED'
,p_operator=>'is null'
,p_condition_sql=>'"INITIATED" is null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(315839212232179178)
,p_plug_name=>'All Duty Travel requests - Department/Sector'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_DIRECTOR_YN = ''Y'' or',
':IS_ED_YN = ''Y'''))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(315839333183179179)
,p_plug_name=>'Missions Reports'
,p_parent_plug_id=>wwv_flow_api.id(315839212232179178)
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
'       mh.PV_NUMBER',
'  from MISSION_HEADER mh, employees_v e',
'  where mh.request_for = e.person_id',
'  and (select distinct d.COST_CENTER ',
'from mission_distributions d',
'where d.request_id = mh.request_id) in (select distinct cost_center',
'                          from COST_CENTERS_FBP',
'                         where ROLE_ID in (81, 82)',
'                         and PERSON_ID = :PERSON_ID',
'                         and STATUS = ''A''',
'                         and sysdate between nvl(start_date , sysdate - 10) ',
'                                        and nvl(end_date , sysdate + 10));'))
,p_plug_source_type=>'NATIVE_IR'
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
 p_id=>wwv_flow_api.id(315839403121179180)
,p_max_row_count=>'1000000'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>426450279611186157
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95234026312386897)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95234458353386898)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::P13_REQUEST_ID,REQUEST_ID,P13_PAGE_FROM:#REQUEST_ID#,#REQUEST_ID#,1'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95234901094386898)
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
 p_id=>wwv_flow_api.id(95235265029386898)
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
 p_id=>wwv_flow_api.id(95235677022386899)
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
 p_id=>wwv_flow_api.id(95236077351386899)
,p_db_column_name=>'GRADE_RATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Grade Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95236438388386899)
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
 p_id=>wwv_flow_api.id(95236828082386899)
,p_db_column_name=>'EMIRATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Emirate'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109829266094654960)
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
 p_id=>wwv_flow_api.id(95237239308386899)
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
 p_id=>wwv_flow_api.id(95237666342386900)
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
 p_id=>wwv_flow_api.id(95238030480386900)
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
 p_id=>wwv_flow_api.id(95238461068386900)
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
 p_id=>wwv_flow_api.id(95238866714386900)
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
 p_id=>wwv_flow_api.id(95239260122386901)
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
 p_id=>wwv_flow_api.id(95239670108386901)
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
 p_id=>wwv_flow_api.id(95240050653386901)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Request Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95240448305386901)
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
 p_id=>wwv_flow_api.id(95240899423386902)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95241303810386902)
,p_db_column_name=>'YEAR'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95241699908386902)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Purpose'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95242063340386902)
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
 p_id=>wwv_flow_api.id(95242430175386903)
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
 p_id=>wwv_flow_api.id(95242908534386903)
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
 p_id=>wwv_flow_api.id(95243246305386903)
,p_db_column_name=>'SEQ'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95243636352386903)
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
 p_id=>wwv_flow_api.id(95244109701386904)
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
 p_id=>wwv_flow_api.id(95244468714386904)
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
 p_id=>wwv_flow_api.id(95244898821386904)
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
 p_id=>wwv_flow_api.id(95245237659386904)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95245652572386904)
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
 p_id=>wwv_flow_api.id(95246034096386905)
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
 p_id=>wwv_flow_api.id(95246479040386905)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95246870475386905)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95247301156386905)
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
 p_id=>wwv_flow_api.id(95247698041386905)
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
 p_id=>wwv_flow_api.id(95248042955386906)
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
 p_id=>wwv_flow_api.id(95248479365386906)
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
 p_id=>wwv_flow_api.id(95248872121386906)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95249239258386906)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95233243143386897)
,p_db_column_name=>'AMOUNT'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95231720982386896)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95232088257386896)
,p_db_column_name=>'SECTOR'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95232461814386897)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95232860743386897)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95233652298386897)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'PV Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(315861805628970482)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2058605'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:REQUEST_FOR:COST_CENTER:EMPLOYEE_NUM:OVERSEAS_YN:START_DATE:END_DATE:COMPLETE_STATUS:AMOUNT:REQUEST_STATUS:'
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
 p_id=>wwv_flow_api.id(95370865749172185)
,p_report_id=>wwv_flow_api.id(315861805628970482)
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
 p_id=>wwv_flow_api.id(95371275193172186)
,p_report_id=>wwv_flow_api.id(315861805628970482)
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
 p_id=>wwv_flow_api.id(95371668362172186)
,p_report_id=>wwv_flow_api.id(315861805628970482)
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
 p_id=>wwv_flow_api.id(95372100636172186)
,p_report_id=>wwv_flow_api.id(315861805628970482)
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
 p_id=>wwv_flow_api.id(95372469087172186)
,p_report_id=>wwv_flow_api.id(315861805628970482)
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
 p_id=>wwv_flow_api.id(95372863235172187)
,p_report_id=>wwv_flow_api.id(315861805628970482)
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
 p_id=>wwv_flow_api.id(124503665673782080)
,p_application_user=>'TCA9234'
,p_name=>'Abdulla'
,p_report_seq=>10
,p_display_rows=>100
,p_report_columns=>'REQUEST_FOR:START_DATE:END_DATE:AMOUNT:REQUEST_STATUS:JUSTIFICATION:REQUEST_NO:'
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
 p_id=>wwv_flow_api.id(124505050930766246)
,p_report_id=>wwv_flow_api.id(124503665673782080)
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
 p_id=>wwv_flow_api.id(124505166369766245)
,p_report_id=>wwv_flow_api.id(124503665673782080)
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
 p_id=>wwv_flow_api.id(124505275550766245)
,p_report_id=>wwv_flow_api.id(124503665673782080)
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
 p_id=>wwv_flow_api.id(124505406800766245)
,p_report_id=>wwv_flow_api.id(124503665673782080)
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
 p_id=>wwv_flow_api.id(124505481340766245)
,p_report_id=>wwv_flow_api.id(124503665673782080)
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
 p_id=>wwv_flow_api.id(124505619880766245)
,p_report_id=>wwv_flow_api.id(124503665673782080)
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
wwv_flow_api.component_end;
end;
/
