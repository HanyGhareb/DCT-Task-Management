prompt --application/pages/page_00034
begin
--   Manifest
--     PAGE: 00034
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>34
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'BTF By Lines'
,p_alias=>'BTF-BY-LINES'
,p_step_title=>'BTF By Lines'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230918172038'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(99869836340894354)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(99869263399894355)
,p_plug_name=>'BTF By Lines'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    l.line_id,',
'    l.request_id,',
'    l.line_no,',
'    l.justification    line_justification,',
'    l.from_to,',
'    l.project_number,',
'    l.task_number,',
'    l.expenditure_type,',
'    l.cost_center,',
'    user_details.get_cost_center_name(l.cost_center) Cost_Center_Name,',
'    user_details.get_cc_sector_name(l.cost_center) Sector,',
'    l.gl_account,',
'    l.budget_group_code,',
'    l.activity,',
'    l.future1,',
'    l.future2,',
'    l.budget,',
'    l.encumbrances,',
'    l.actual,',
'    l.requested_amount,',
'    l.fund_available,',
'    h.REQUEST_NO, ',
'    h.REQUEST_DATE, ',
'    h.REQUIRED_DATE, ',
'    h.REQUEST_STATUS, ',
'    h.JUSTIFICATION  Header_justification, ',
'    h.YEAR, ',
'    h.PURPOSE_EU, ',
'    h.PRIORITY, ',
'    h.SUBMITTED_ON, ',
'    h.SUBMITTED_BY, ',
'    h.FINAL_APPROVE_ON, ',
'    h.CREATED_BY_PERSON_ID, ',
'    h.CREATION_DATE,',
'    h.UPDATED_BY_PERSON_ID, ',
'    h.FINAL_REJECT_ON, ',
'    h.REJECTED_BY, ',
'    h.REJECT_REASON, ',
'    h.CANCEL_ON, ',
'    h.CANCELLED_BY, ',
'    h.CANCEL_REASON, ',
'    h.EXECUTED_YN,',
'    h.EXECUTED_ON,',
'    h.approval_case_id,',
'    BTF_EU_UTIL.get_pending_balance(''FROM'',l.PROJECT_NUMBER,l.TASK_NUMBER, l.EXPENDITURE_TYPE, SUBSTR(l.EXPENDITURE_TYPE,1,6) ) from_Pending_balance,',
'    BTF_EU_UTIL.get_pending_balance(''TO'',l.PROJECT_NUMBER,l.TASK_NUMBER, l.EXPENDITURE_TYPE, SUBSTR(l.EXPENDITURE_TYPE,1,6) ) to_Pending_balance',
'FROM    btf_end_users_lines l, btf_end_users_header h',
'where l.REQUEST_ID = h.REQUEST_ID',
'and  h.YEAR             = nvl(:P34_FISICAL_YEAR , h.year)',
'and  l.from_to          = nvl(:P34_FROM_TO          , l.from_to )',
'and  l.project_number   = NVL(:P34_PROJECT_NUMBER   , l.project_number)',
'and  l.task_number      = NVL(:P34_TASK_NUMBER      , l.task_number)',
'and  l.expenditure_type = NVL(:P34_EXPENDITURE_TYPE , l.expenditure_type)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P34_FISICAL_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Budget Transfer Requests By Lines'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'14'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#FF2D55'
,p_prn_header_font_color=>'#FFFFFF'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'11'
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
 p_id=>wwv_flow_api.id(99869206961894355)
,p_name=>'BTF By Lines'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>113414825427290277
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99868803689894358)
,p_db_column_name=>'LINE_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99868365154894359)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99867999431894360)
,p_db_column_name=>'LINE_NO'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Line No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99867540458894360)
,p_db_column_name=>'LINE_JUSTIFICATION'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Line Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99867140765894360)
,p_db_column_name=>'FROM_TO'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'From /To'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99866747210894360)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99866382624894360)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99865978792894361)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99865619538894361)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99865136202894361)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99864773979894361)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Budget Group'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99864348828894361)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99863953264894362)
,p_db_column_name=>'FUTURE1'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99863575862894362)
,p_db_column_name=>'FUTURE2'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99863181527894362)
,p_db_column_name=>'BUDGET'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99862817921894362)
,p_db_column_name=>'ENCUMBRANCES'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Encumbrances'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99862392709894362)
,p_db_column_name=>'ACTUAL'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99862016721894363)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99861630493894363)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99861207045894363)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'BTF No'
,p_column_link=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_REQUEST_ID,P42_PAGE_FROM,REQUEST_ID:#REQUEST_ID#,34,#REQUEST_ID#'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99860784902894363)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99860424916894363)
,p_db_column_name=>'REQUIRED_DATE'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Required Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99859939772894364)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Request Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99859533202894364)
,p_db_column_name=>'HEADER_JUSTIFICATION'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Header Justification'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99859227584894364)
,p_db_column_name=>'YEAR'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99858800497894364)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Purpose Eu'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99858409362894364)
,p_db_column_name=>'PRIORITY'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48255921784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99857976506894365)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99857560169894365)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99857216793894365)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99856741374894365)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99856403370894365)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99856023208894366)
,p_db_column_name=>'FINAL_REJECT_ON'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Final Reject On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99855623610894366)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99855191085894366)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99854793406894366)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99854365277894366)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99853964270894367)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99853557219894367)
,p_db_column_name=>'EXECUTED_YN'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Executed ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95594621914377217)
,p_db_column_name=>'FROM_PENDING_BALANCE'
,p_display_order=>49
,p_column_identifier=>'AN'
,p_column_label=>'Deduction Pending'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95594455226377216)
,p_db_column_name=>'TO_PENDING_BALANCE'
,p_display_order=>59
,p_column_identifier=>'AO'
,p_column_label=>'Additional Pending'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(90738566612552490)
,p_db_column_name=>'SECTOR'
,p_display_order=>69
,p_column_identifier=>'AP'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(90738464976552489)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>79
,p_column_identifier=>'AQ'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(90737942209552484)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>89
,p_column_identifier=>'AR'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(45325075330072002)
,p_db_column_name=>'EXECUTED_ON'
,p_display_order=>99
,p_column_identifier=>'AS'
,p_column_label=>'Executed On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24019521928356894)
,p_db_column_name=>'APPROVAL_CASE_ID'
,p_display_order=>109
,p_column_identifier=>'AT'
,p_column_label=>'Approval Case'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(22579478575036725)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(99852485760900556)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1134316'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:HEADER_JUSTIFICATION:CREATED_BY_PERSON_ID:FROM_TO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:GL_ACCOUNT:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:REQUESTED_AMOUNT:FROM_PENDING_BALANCE:TO_PENDING_BALANCE:RE'
||'QUEST_STATUS:EXECUTED_YN::SECTOR:CREATION_DATE:COST_CENTER_NAME:EXECUTED_ON:APPROVAL_CASE_ID'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(63736196105001520)
,p_report_id=>wwv_flow_api.id(99852485760900556)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUESTED_AMOUNT'
,p_operator=>'>='
,p_expr=>'0'
,p_condition_sql=>' (case when ("REQUESTED_AMOUNT" >= to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#9DE8DC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(63735771849001520)
,p_report_id=>wwv_flow_api.id(99852485760900556)
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
 p_id=>wwv_flow_api.id(63735388648001520)
,p_report_id=>wwv_flow_api.id(99852485760900556)
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
 p_id=>wwv_flow_api.id(63734996383001520)
,p_report_id=>wwv_flow_api.id(99852485760900556)
,p_name=>'in-Progress'
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
 p_id=>wwv_flow_api.id(82164580538188139)
,p_application_user=>'TCA9051'
,p_name=>'BTF From Date'
,p_description=>'All BTF Submitted from Specific Date'
,p_report_seq=>10
,p_report_alias=>'1311195'
,p_status=>'PUBLIC'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:HEADER_JUSTIFICATION:CREATED_BY_PERSON_ID:FROM_TO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:GL_ACCOUNT:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:REQUESTED_AMOUNT:FROM_PENDING_BALANCE:TO_PENDING_BALANCE:RE'
||'QUEST_STATUS:EXECUTED_YN::SECTOR:CREATION_DATE:COST_CENTER_NAME'
,p_sort_column_1=>'SUBMITTED_ON'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'REQUEST_NO'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'FROM_TO'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(82161031788193001)
,p_report_id=>wwv_flow_api.id(82164580538188139)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUESTED_AMOUNT'
,p_operator=>'>='
,p_expr=>'0'
,p_condition_sql=>' (case when ("REQUESTED_AMOUNT" >= to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#9DE8DC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(82160548899193002)
,p_report_id=>wwv_flow_api.id(82164580538188139)
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
 p_id=>wwv_flow_api.id(82160181010193002)
,p_report_id=>wwv_flow_api.id(82164580538188139)
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
 p_id=>wwv_flow_api.id(82159813302193002)
,p_report_id=>wwv_flow_api.id(82164580538188139)
,p_name=>'in-Progress'
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
 p_id=>wwv_flow_api.id(82161344961193001)
,p_report_id=>wwv_flow_api.id(82164580538188139)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'SUBMITTED_ON'
,p_operator=>'>='
,p_expr=>'20220901010000'
,p_condition_sql=>'"SUBMITTED_ON" >= to_date(#APXWS_EXPR#,''YYYYMMDDHH24MISS'')'
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_DATE#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(50878216048810806)
,p_application_user=>'TCA9051'
,p_name=>'Pending 4511000181'
,p_description=>'Pending BTF for 4511000181'
,p_report_seq=>10
,p_report_alias=>'1624059'
,p_status=>'PUBLIC'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:HEADER_JUSTIFICATION:CREATED_BY_PERSON_ID:FROM_TO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:GL_ACCOUNT:FUTURE2:BUDGET:FUND_AVAILABLE:REQUESTED_AMOUNT:FROM_PENDING_BALANCE:TO_PENDING_BALANCE:REQUEST_STATUS:EXECUTE'
||'D_YN:SECTOR:CREATION_DATE:COST_CENTER_NAME:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(50876967973810799)
,p_report_id=>wwv_flow_api.id(50878216048810806)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUESTED_AMOUNT'
,p_operator=>'>='
,p_expr=>'0'
,p_condition_sql=>' (case when ("REQUESTED_AMOUNT" >= to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#9DE8DC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(50876622233810799)
,p_report_id=>wwv_flow_api.id(50878216048810806)
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
 p_id=>wwv_flow_api.id(50876221180810799)
,p_report_id=>wwv_flow_api.id(50878216048810806)
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
 p_id=>wwv_flow_api.id(50875819243810799)
,p_report_id=>wwv_flow_api.id(50878216048810806)
,p_name=>'in-Progress'
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
 p_id=>wwv_flow_api.id(50877767770810802)
,p_report_id=>wwv_flow_api.id(50878216048810806)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'PROJECT_NUMBER'
,p_operator=>'='
,p_expr=>'4511000181'
,p_condition_sql=>'"PROJECT_NUMBER" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''4511000181''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(50877333426810800)
,p_report_id=>wwv_flow_api.id(50878216048810806)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'not in'
,p_expr=>'Cancel,Approved,Rejected'
,p_condition_sql=>'"REQUEST_STATUS" not in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#, #APXWS_EXPR_VAL3#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Cancel, Approved, Rejected''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(39107625721433644)
,p_application_user=>'TCA9051'
,p_name=>'IT Approved - To BTF'
,p_report_seq=>10
,p_report_alias=>'1741765'
,p_status=>'PUBLIC'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:HEADER_JUSTIFICATION:CREATED_BY_PERSON_ID:FROM_TO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:GL_ACCOUNT:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:REQUESTED_AMOUNT:FROM_PENDING_BALANCE:TO_PENDING_BALANCE:RE'
||'QUEST_STATUS:EXECUTED_YN::SECTOR:CREATION_DATE:COST_CENTER_NAME:EXECUTED_ON'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(39106019405433639)
,p_report_id=>wwv_flow_api.id(39107625721433644)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUESTED_AMOUNT'
,p_operator=>'>='
,p_expr=>'0'
,p_condition_sql=>' (case when ("REQUESTED_AMOUNT" >= to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#9DE8DC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(39105533534433639)
,p_report_id=>wwv_flow_api.id(39107625721433644)
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
 p_id=>wwv_flow_api.id(39105168126433639)
,p_report_id=>wwv_flow_api.id(39107625721433644)
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
 p_id=>wwv_flow_api.id(39104798267433638)
,p_report_id=>wwv_flow_api.id(39107625721433644)
,p_name=>'in-Progress'
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
 p_id=>wwv_flow_api.id(39107211270433643)
,p_report_id=>wwv_flow_api.id(39107625721433644)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'COST_CENTER'
,p_operator=>'='
,p_expr=>'4510250'
,p_condition_sql=>'"COST_CENTER" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''4510250''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(39106825907433640)
,p_report_id=>wwv_flow_api.id(39107625721433644)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'FROM_TO'
,p_operator=>'='
,p_expr=>'TO'
,p_condition_sql=>'"FROM_TO" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''TO''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(39106332503433640)
,p_report_id=>wwv_flow_api.id(39107625721433644)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>'"REQUEST_STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(28437918018755329)
,p_application_user=>'TCA9051'
,p_name=>'All BTF Requests By Year'
,p_report_seq=>10
,p_report_alias=>'1848462'
,p_status=>'PUBLIC'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:HEADER_JUSTIFICATION:CREATED_BY_PERSON_ID:FROM_TO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:GL_ACCOUNT:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:REQUESTED_AMOUNT:FROM_PENDING_BALANCE:TO_PENDING_BALANCE:RE'
||'QUEST_STATUS:EXECUTED_YN:SECTOR:CREATION_DATE:COST_CENTER_NAME:EXECUTED_ON:CANCEL_ON:CANCEL_REASON:CANCELLED_BY:FINAL_APPROVE_ON:FINAL_REJECT_ON:REJECT_REASON:REJECTED_BY:SUBMITTED_BY:SUBMITTED_ON:'
,p_sort_column_1=>'REQUEST_NO'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'FROM_TO'
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
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28437481563755311)
,p_report_id=>wwv_flow_api.id(28437918018755329)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUESTED_AMOUNT'
,p_operator=>'>='
,p_expr=>'0'
,p_condition_sql=>' (case when ("REQUESTED_AMOUNT" >= to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#9DE8DC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(28437073287755311)
,p_report_id=>wwv_flow_api.id(28437918018755329)
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
 p_id=>wwv_flow_api.id(28436709199755311)
,p_report_id=>wwv_flow_api.id(28437918018755329)
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
 p_id=>wwv_flow_api.id(28436280453755310)
,p_report_id=>wwv_flow_api.id(28437918018755329)
,p_name=>'in-Progress'
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
 p_id=>wwv_flow_api.id(99653820118885461)
,p_application_user=>'TCA1428'
,p_name=>'test'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:REQUIRED_DATE:REQUEST_STATUS:HEADER_JUSTIFICATION:PRIORITY:SUBMITTED_ON:SUBMITTED_BY:FINAL_APPROVE_ON:CREATED_BY_PERSON_ID:UPDATED_BY_PERSON_ID:FINAL_REJECT_ON:REJECTED_BY:REJECT_REASON:CANCEL_ON:CANCELLED_BY:CANCEL_REASON:EXE'
||'CUTED_YN:LINE_NO:LINE_JUSTIFICATION:FROM_TO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:GL_ACCOUNT:BUDGET_GROUP_CODE:ACTIVITY:FUTURE1:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:REQUESTED_AMOUNT:FUND_AVAILABLE:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(99653644307885461)
,p_report_id=>wwv_flow_api.id(99653820118885461)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'PROJECT_NUMBER'
,p_operator=>'='
,p_expr=>'4511000036'
,p_condition_sql=>' (case when ("PROJECT_NUMBER" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''4511000036''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(99651685798899720)
,p_application_user=>'TCA1428'
,p_name=>'test 2'
,p_report_seq=>10
,p_report_type=>'GROUP_BY'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:REQUIRED_DATE:REQUEST_STATUS:HEADER_JUSTIFICATION:PRIORITY:SUBMITTED_ON:SUBMITTED_BY:FINAL_APPROVE_ON:CREATED_BY_PERSON_ID:UPDATED_BY_PERSON_ID:FINAL_REJECT_ON:REJECTED_BY:REJECT_REASON:CANCEL_ON:CANCELLED_BY:CANCEL_REASON:EXE'
||'CUTED_YN:LINE_NO:LINE_JUSTIFICATION:FROM_TO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:GL_ACCOUNT:BUDGET_GROUP_CODE:ACTIVITY:FUTURE1:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:REQUESTED_AMOUNT:FUND_AVAILABLE:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(99651618012899728)
,p_report_id=>wwv_flow_api.id(99651685798899720)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'PROJECT_NUMBER'
,p_operator=>'='
,p_expr=>'4511000036'
,p_condition_sql=>' (case when ("PROJECT_NUMBER" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''4511000036''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
);
wwv_flow_api.create_worksheet_group_by(
 p_id=>wwv_flow_api.id(99651472991899728)
,p_report_id=>wwv_flow_api.id(99651685798899720)
,p_group_by_columns=>'REQUEST_STATUS'
,p_function_01=>'SUM'
,p_function_column_01=>'REQUESTED_AMOUNT'
,p_function_db_column_name_01=>'APXWS_GBFC_01'
,p_function_label_01=>'total amount'
,p_function_format_mask_01=>'999G999G999G999G990D00'
,p_function_sum_01=>'N'
,p_function_02=>'COUNT'
,p_function_column_02=>'REQUEST_NO'
,p_function_db_column_name_02=>'APXWS_GBFC_02'
,p_function_label_02=>'Count'
,p_function_format_mask_02=>'999G999G999G999G990'
,p_function_sum_02=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(88702447799330230)
,p_application_user=>'TCA9051'
,p_name=>'BTF - Jul2022'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:HEADER_JUSTIFICATION:CREATED_BY_PERSON_ID:FROM_TO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:GL_ACCOUNT:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:REQUESTED_AMOUNT:FROM_PENDING_BALANCE:TO_PENDING_BALANCE:RE'
||'QUEST_STATUS:EXECUTED_YN::SECTOR:CREATION_DATE:COST_CENTER_NAME'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(88702278625330230)
,p_report_id=>wwv_flow_api.id(88702447799330230)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUESTED_AMOUNT'
,p_operator=>'>='
,p_expr=>'0'
,p_condition_sql=>' (case when ("REQUESTED_AMOUNT" >= to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#9DE8DC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(88702213781330230)
,p_report_id=>wwv_flow_api.id(88702447799330230)
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
 p_id=>wwv_flow_api.id(88702099015330230)
,p_report_id=>wwv_flow_api.id(88702447799330230)
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
 p_id=>wwv_flow_api.id(88701972802330230)
,p_report_id=>wwv_flow_api.id(88702447799330230)
,p_name=>'in-Progress'
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
 p_id=>wwv_flow_api.id(88702427789330230)
,p_report_id=>wwv_flow_api.id(88702447799330230)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'FINAL_APPROVE_ON'
,p_operator=>'between'
,p_expr=>'20220701010000'
,p_expr2=>'20220731125900'
,p_condition_sql=>'"FINAL_APPROVE_ON" between to_date(#APXWS_EXPR#,''YYYYMMDDHH24MISS'') and to_date(#APXWS_EXPR2#,''YYYYMMDDHH24MISS'')'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# #APXWS_EXPR_DATE# #APXWS_AND# #APXWS_EXPR2_DATE#'
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(88697088702554757)
,p_application_user=>'TCA9051'
,p_name=>'BTF - Jul2022 - V2'
,p_report_seq=>10
,p_report_type=>'GROUP_BY'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:HEADER_JUSTIFICATION:CREATED_BY_PERSON_ID:FROM_TO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:GL_ACCOUNT:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:REQUESTED_AMOUNT:FROM_PENDING_BALANCE:TO_PENDING_BALANCE:RE'
||'QUEST_STATUS:EXECUTED_YN::SECTOR:CREATION_DATE:COST_CENTER_NAME'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(88696877218554758)
,p_report_id=>wwv_flow_api.id(88697088702554757)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUESTED_AMOUNT'
,p_operator=>'>='
,p_expr=>'0'
,p_condition_sql=>' (case when ("REQUESTED_AMOUNT" >= to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#9DE8DC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(88696817233554758)
,p_report_id=>wwv_flow_api.id(88697088702554757)
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
 p_id=>wwv_flow_api.id(88696678584554758)
,p_report_id=>wwv_flow_api.id(88697088702554757)
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
 p_id=>wwv_flow_api.id(88696533569554758)
,p_report_id=>wwv_flow_api.id(88697088702554757)
,p_name=>'in-Progress'
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
 p_id=>wwv_flow_api.id(88696988190554758)
,p_report_id=>wwv_flow_api.id(88697088702554757)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'FINAL_APPROVE_ON'
,p_operator=>'between'
,p_expr=>'20220701010000'
,p_expr2=>'20220731125900'
,p_condition_sql=>'"FINAL_APPROVE_ON" between to_date(#APXWS_EXPR#,''YYYYMMDDHH24MISS'') and to_date(#APXWS_EXPR2#,''YYYYMMDDHH24MISS'')'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# #APXWS_EXPR_DATE# #APXWS_AND# #APXWS_EXPR2_DATE#'
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_group_by(
 p_id=>wwv_flow_api.id(88696472566554758)
,p_report_id=>wwv_flow_api.id(88697088702554757)
,p_group_by_columns=>'SECTOR:COST_CENTER_NAME:FROM_TO'
,p_function_01=>'SUM'
,p_function_column_01=>'REQUESTED_AMOUNT'
,p_function_db_column_name_01=>'APXWS_GBFC_01'
,p_function_format_mask_01=>'999G999G999G999G990'
,p_function_sum_01=>'N'
,p_function_02=>'SUM'
,p_function_column_02=>'BUDGET'
,p_function_db_column_name_02=>'APXWS_GBFC_02'
,p_function_format_mask_02=>'999G999G999G999G990D00'
,p_function_sum_02=>'N'
,p_sort_column_01=>'SECTOR'
,p_sort_direction_01=>'ASC'
,p_sort_column_02=>'COST_CENTER_NAME'
,p_sort_direction_02=>'ASC'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(86376846262032550)
,p_application_user=>'TCA1428'
,p_name=>'Manju'
,p_description=>'Strategic Initiative'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:CREATED_BY_PERSON_ID:FROM_TO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:COST_CENTER_NAME:GL_ACCOUNT:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:REQUESTED_AMOUNT:FROM_PENDING_BALANCE:TO_PENDING_BALANCE:REQUES'
||'T_STATUS:EXECUTED_YN:SECTOR:CREATION_DATE:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(86376763288032550)
,p_report_id=>wwv_flow_api.id(86376846262032550)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUESTED_AMOUNT'
,p_operator=>'>='
,p_expr=>'0'
,p_condition_sql=>' (case when ("REQUESTED_AMOUNT" >= to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# >= #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#9DE8DC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(86376664675032550)
,p_report_id=>wwv_flow_api.id(86376846262032550)
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
 p_id=>wwv_flow_api.id(86376570643032550)
,p_report_id=>wwv_flow_api.id(86376846262032550)
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
 p_id=>wwv_flow_api.id(86376494732032550)
,p_report_id=>wwv_flow_api.id(86376846262032550)
,p_name=>'in-Progress'
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
 p_id=>wwv_flow_api.id(35919943368587413)
,p_application_user=>'TCA9079'
,p_name=>'IT lines items transferred to IT'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:HEADER_JUSTIFICATION:CREATED_BY_PERSON_ID:FROM_TO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:GL_ACCOUNT:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:REQUESTED_AMOUNT:FROM_PENDING_BALANCE:TO_PENDING_BALANCE:RE'
||'QUEST_STATUS:EXECUTED_YN::SECTOR:CREATION_DATE:COST_CENTER_NAME:EXECUTED_ON'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(35919803641587412)
,p_report_id=>wwv_flow_api.id(35919943368587413)
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
 p_id=>wwv_flow_api.id(35919700334587412)
,p_report_id=>wwv_flow_api.id(35919943368587413)
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
 p_id=>wwv_flow_api.id(35919599610587412)
,p_report_id=>wwv_flow_api.id(35919943368587413)
,p_name=>'in-Progress'
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
 p_id=>wwv_flow_api.id(35919862453587412)
,p_report_id=>wwv_flow_api.id(35919943368587413)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'COST_CENTER'
,p_operator=>'='
,p_expr=>'4510250'
,p_condition_sql=>'"COST_CENTER" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''4510250''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(95594378137377215)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(99869836340894354)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P34_PAGE_FROM.:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95594955266377221)
,p_name=>'P34_FROM_TO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(99869836340894354)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95594866728377220)
,p_name=>'P34_PROJECT_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(99869836340894354)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95594753906377219)
,p_name=>'P34_TASK_NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(99869836340894354)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95594701183377218)
,p_name=>'P34_EXPENDITURE_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(99869836340894354)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(95594243601377214)
,p_name=>'P34_PAGE_FROM'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(99869836340894354)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70877381160360804)
,p_name=>'P34_FISICAL_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(99869263399894355)
,p_item_default=>'2023'
,p_prompt=>'Fisical Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:2022;2022,2023;2023'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- All --'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70877315063360803)
,p_name=>'Fisical year Changed DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P34_FISICAL_YEAR'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70877188959360802)
,p_event_id=>wwv_flow_api.id(70877315063360803)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(99869263399894355)
);
wwv_flow_api.component_end;
end;
/
