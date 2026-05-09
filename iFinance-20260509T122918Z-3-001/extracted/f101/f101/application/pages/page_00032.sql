prompt --application/pages/page_00032
begin
--   Manifest
--     PAGE: 00032
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>32
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Expense Report Approve / Reject'
,p_alias=>'EXPENSE-REPORT-APPROVE-REJECTS'
,p_step_title=>'Expense Report Approve / Reject'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'		',
'		/* Scroll Results Only in Side Column */',
'.t-Body-side {',
'    display: flex;',
'    flex-direction: column;',
'    overflow: hidden;',
'}',
'.search-results {',
'    flex: 1;',
'    overflow: auto;',
'}',
'/* Format Search Region */',
'.search-region {',
'    border-bottom: 1px solid rgba(0,0,0,.1);',
'    flex-shrink: 0;',
'}',
'',
'.t-Region-header{',
'                background-color:#0e6655;',
'                color:black;',
'                }',
'.t-Region-title{',
'            color:black;',
'            font-weighfont-weight: bold;',
'                }',
'',
'/* Custom Header color */',
'#inside-page .t-Region-header{',
'    background-color :#81d0b5;',
'    font-weighfont-weight: bold;',
'}',
'',
'',
'/* Set Header Panel */',
'.t-Header-branding {',
'    background-color: #0e6655;',
'}',
'',
'',
'/* Set Breadcrumb   */',
'.t-Body-title {',
'',
'    background-color: #EEE;',
'    color:#404040;',
'}',
'',
'/* Add Button - White */',
'.t-Region-header, .t-Region-header .t-Button--link, .t-Region-header .t-Button--noUI {',
'    color:  #FFF;',
'}',
'',
'/* New Plan Button */',
'.a-Button--hot, .t-Button--hot:not(.t-Button--simple), body .ui-button.ui-button--hot, body .ui-state-default.ui-priority-primary {',
'',
'    background-color: #0e6655;',
'    color:#fff;',
'}',
'',
'',
'/*  Table Row Selected */',
'.a-GV-table tr.is-selected .a-GV-cell {',
'    background-color: #CEF6CE;',
'}',
'',
'/* Audit Region */',
'#history    .t-Region-header {',
'     background-color: #cae6e3;',
'    color:#000;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'ALWAYS'
,p_last_updated_by=>'TCA1345'
,p_last_upd_yyyymmddhh24miss=>'20211125104544'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7196343938438594)
,p_plug_name=>'Previous Requests '
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8040898187175502)
,p_plug_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7196229847438593)
,p_plug_name=>'Expense Reports History'
,p_parent_plug_id=>wwv_flow_api.id(7196343938438594)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'EXPENSE_REPORTS_ALL_V'
,p_query_where=>'EMPLOYEE_NUM = :P32_EMPLOYEE_NUM'
,p_query_order_by=>'EXPENSE_REPORT_DATE desc'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P32_EMPLOYEE_NUM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Expense Reports History'
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
 p_id=>wwv_flow_api.id(1571880484224289)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>31120217752238225
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1571779374224288)
,p_db_column_name=>'EXPENSE_REPORT_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Expense Report Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1571648071224287)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1571558599224286)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Petty Cash No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1571409999224285)
,p_db_column_name=>'PETTY_CASH_AMOUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Petty Cash Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1571364130224284)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Petty Cash Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1571255209224283)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Petty Cash Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1571125501224282)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1571013470224281)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1570906392224280)
,p_db_column_name=>'EMPLOYEE_SECTOR'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Employee Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1570820156224279)
,p_db_column_name=>'EMPLOYEE_DEPARTMENT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Employee Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1570706875224278)
,p_db_column_name=>'EMPLOYEE_ORGANIZATION'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Employee Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1570691700224277)
,p_db_column_name=>'EMPLOYEE_SUPERVISOR'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Employee Supervisor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1570502771224276)
,p_db_column_name=>'EMPLOYEE_SUPERVISOR_NUM'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Employee Supervisor Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1570431394224275)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1570384229224274)
,p_db_column_name=>'GL_ACCOUNT_NAME'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Gl Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1570244511224273)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1570108928224272)
,p_db_column_name=>'GL_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1570085507224271)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1569979144224270)
,p_db_column_name=>'TASK'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1569839346224269)
,p_db_column_name=>'PETTY_CASH_PRIORITY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Petty Cash Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1569701631224268)
,p_db_column_name=>'PETTY_CASH_STATU'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Petty Cash Statu'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1569689482224267)
,p_db_column_name=>'PETTY_CASH_APPROVAL_STATUS'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Petty Cash Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1569566745224266)
,p_db_column_name=>'PETTY_CASH_JUSTIFICATION'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Petty Cash Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1569468344224265)
,p_db_column_name=>'PETTY_CASH_PV_NUMBER'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Petty Cash Pv Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1569395863224264)
,p_db_column_name=>'PETTY_CASH_CREATED_BY'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Petty Cash Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1552353200249113)
,p_db_column_name=>'PETTY_CASH_CREATION_DATE'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Petty Cash Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1552203174249112)
,p_db_column_name=>'PETTY_CASH_PAID_YN'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Petty Cash Paid Yn'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1552177994249111)
,p_db_column_name=>'PETTY_CASH_INVOICING_YN'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Petty Cash Invoicing Yn'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1552080953249110)
,p_db_column_name=>'PETTY_CASH_INVOICE_DATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Petty Cash Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1551974223249109)
,p_db_column_name=>'PETTY_CASH_INVOICE_NUMBER'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Petty Cash Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1551854756249108)
,p_db_column_name=>'PETTY_CASH_PAYMENT_NUMBER'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Petty Cash Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1551703809249107)
,p_db_column_name=>'PETTY_CASH_PAYMENT_DATE'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Petty Cash Payment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1551632094249106)
,p_db_column_name=>'EXPENSE_REPORT_DATE'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1551551917249105)
,p_db_column_name=>'EXPENSE_REPORT_PURPOSE'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1551420772249104)
,p_db_column_name=>'EXPENSE_REPORT_APPROVAL_STATUS'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1551345275249103)
,p_db_column_name=>'EXPENSE_REPORT_INVOICING_YN'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Invoicing ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1551219435249102)
,p_db_column_name=>'EXPENSE_REPORT_PRIORITY'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1551123963249101)
,p_db_column_name=>'EXPENSE_REPORT_JUSTIFICATION'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1551097819249100)
,p_db_column_name=>'EXPENSE_REPORT_COMMENT'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1550922241249099)
,p_db_column_name=>'EXPENSE_REPORT_CREATION_DATE'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Expense Report Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1550814834249098)
,p_db_column_name=>'EXPENSE_REPORT_CREATED_BY'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Expense Report Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1550764994249097)
,p_db_column_name=>'EXPENSE_REPORT_UPDATED_BY'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Expense Report Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1550599976249096)
,p_db_column_name=>'EXPENSE_REPORT_UPDATED_DATE'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Expense Report Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1550562577249095)
,p_db_column_name=>'EXPENSE_REPORT_YEAR'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Expense Report Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1550471207249094)
,p_db_column_name=>'EXPENSE_REPORT_NUM'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Expense Report Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1550312532249093)
,p_db_column_name=>'EXPENSE_REPORT_PAID_YN'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Paid ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1550278320249092)
,p_db_column_name=>'PENDING_WITH_AP'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Pending With AP'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1550176245249091)
,p_db_column_name=>'EXPENSE_REPORT_TYPE'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Expense Report Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1550081816249090)
,p_db_column_name=>'EXPENSE_REPORT_ORG_ID'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Expense Report Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1549979643249089)
,p_db_column_name=>'EXPENSE_REPORT_EMP_NUM'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Expense Report Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1549856769249088)
,p_db_column_name=>'EXPENSE_REPORT_EMP_NAME'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Expense Report Emp Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1549734870249087)
,p_db_column_name=>'EXPENSE_REPORT_AMOUNT'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1549649523249086)
,p_db_column_name=>'PHOTO'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1514753900250180)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'311774'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_AMOUNT:PETTY_CASH_JUSTIFICATION:EXPENSE_REPORT_TYPE:EXPENSE_REPORT_JUSTIFICATION:EXPENSE_REPORT_AMOUNT:PHOTO:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4670704918660443)
,p_plug_name=>'Expense Report Details'
,p_region_name=>'inside-page'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'HRSS_EXPENSE_REPORTS'
,p_include_rowid_column=>false
,p_is_editable=>false
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6403317518706760)
,p_plug_name=>'Expense Report Details'
,p_region_name=>'inside-page'
,p_parent_plug_id=>wwv_flow_api.id(4670704918660443)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6403402786706761)
,p_plug_name=>'Petty Cash Details'
,p_region_name=>'inside-page'
,p_parent_plug_id=>wwv_flow_api.id(4670704918660443)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6403632666706763)
,p_plug_name=>'Audit'
,p_region_name=>'inside-page'
,p_parent_plug_id=>wwv_flow_api.id(4670704918660443)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8040898187175502)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(42756267985634128)
,p_plug_name=>'Collaboration'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>50
,p_plug_new_grid_row=>false
,p_plug_display_column=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P32_EXPENSE_REPORT_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(51387002248190091)
,p_name=>'Messages Report'
,p_region_name=>'projectUpdates'
,p_parent_plug_id=>wwv_flow_api.id(42756267985634128)
,p_template=>wwv_flow_api.id(8030481219175499)
,p_display_sequence=>10
,p_region_css_classes=>'updates-region'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_new_grid_row=>false
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'  CASE',
'        WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END  user_icon,',
'  updated_date  comment_date,',
'  (select e.full_name_en',
'    from dct_employees_list2 e',
'    where e.user_name = created_by) user_name,',
'  comment_text                    comment_text,',
'  null comment_modifiers,',
'  ''u-color-''||ora_hash(created_by,45) icon_modifier,',
'  action     actions,',
'  ''''     attribute_1,',
'  ''''     attribute_2,',
'  ''''    attribute_3,',
'  ''''    attribute_4,',
'  comment_id',
'from',
'  (SELECT',
'    c.comment_id,',
'    c.EXPENSE_REPORT_ID,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action,',
'    e.user_name,',
'    e.photo_blob    ',
'FROM',
'    HRSS_EXPENSE_REPORT_COMMENTS c , dct_employees_list2 e',
'where c.updated_by = e.user_name    )',
'where EXPENSE_REPORT_ID = :P32_EXPENSE_REPORT_ID',
'order by UPDATED_DATE desc;',
''))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P32_EXPENSE_REPORT_ID'
,p_query_row_template=>wwv_flow_api.id(8086778490175517)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Communications yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4751445580900545)
,p_query_column_id=>1
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>1
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#USER_ICON#" alt="Image Not Found" height="40" width="40">'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4751770005900545)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4752216056900545)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4752634791900546)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::P21_COMMENT_ID,P21_ACTION:#COMMENT_ID#,Edited'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4753024682900546)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4753429317900546)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4753773654900546)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4754239565900546)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4754604257900547)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4755035464900547)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4755401286900547)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4755785272900547)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(43864597620179845)
,p_plug_name=>'Documents'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-book fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P32_EXPENSE_REPORT_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(43864734773179846)
,p_plug_name=>'Expense Report Documents Report'
,p_parent_plug_id=>wwv_flow_api.id(43864597620179845)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       EXPENSE_REPORT_ID,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from EXPENSE_REPORT_DOCUMENTS',
' where EXPENSE_REPORT_ID = :P32_EXPENSE_REPORT_ID',
' order by created desc',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P32_EXPENSE_REPORT_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Expense Report Documents Report'
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
 p_id=>wwv_flow_api.id(43864942057179848)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'There is no attachments. '
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>45854980384243612
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4604203953566105)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4604586664566105)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4605018398566106)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.::P20_ID,P20_EXPENSE_REPORT_APPROVAL_STATUS:#ID#,&P32_APPROVAL_STATUS.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4605456255566106)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4605780340566106)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4606217070566106)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'File Blob'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'OTHER'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4606601889566107)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4607013224566107)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4607383793566107)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4607844019566107)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4608247389566107)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4608602254566108)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4608968592566108)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4609434108566108)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:EXPENSE_REPORT_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4673383170660470)
,p_db_column_name=>'EXPENSE_REPORT_ID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Expense Report Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(44001628939880980)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'66002'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(43875199948196124)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(46510105260113497)
,p_name=>'Lines'
,p_region_name=>'inside-page'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_css_classes=>'js-detail-region'
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'t-Report--stretch:#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline'
,p_grid_column_span=>9
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'HRSS_EXPENSE_REPORT_LINES'
,p_query_where=>'"EXPENSE_REPORT_ID" = :P32_EXPENSE_REPORT_ID'
,p_include_rowid_column=>true
,p_display_when_condition=>'P32_EXPENSE_REPORT_ID'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P32_EXPENSE_REPORT_ID'
,p_query_row_template=>wwv_flow_api.id(8084165237175515)
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No data found.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>5000
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6499325530699058)
,p_query_column_id=>1
,p_column_alias=>'LINE_ID'
,p_column_display_sequence=>1
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6499701720699059)
,p_query_column_id=>2
,p_column_alias=>'EXPENSE_REPORT_ID'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6500062105699059)
,p_query_column_id=>3
,p_column_alias=>'EXPENSE_DATE'
,p_column_display_sequence=>3
,p_column_heading=>'Expense Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6500546661699059)
,p_query_column_id=>4
,p_column_alias=>'RECEIPT_AMOUNT'
,p_column_display_sequence=>4
,p_column_heading=>'Receipt Amount'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6500930953699059)
,p_query_column_id=>5
,p_column_alias=>'EXPENSE_TYPE'
,p_column_display_sequence=>5
,p_column_heading=>'Expense Type'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6501314303699059)
,p_query_column_id=>6
,p_column_alias=>'JUSTIFICATION'
,p_column_display_sequence=>6
,p_column_heading=>'Justification'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6501737647699060)
,p_query_column_id=>7
,p_column_alias=>'COMMENT_TO_APPROVER'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6502148499699060)
,p_query_column_id=>8
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6502492956699060)
,p_query_column_id=>9
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6502938255699060)
,p_query_column_id=>10
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>10
,p_column_heading=>'Updated By'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6503265398699060)
,p_query_column_id=>11
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>11
,p_column_heading=>'Updated Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(58172382556005902)
,p_plug_name=>'Approval History'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-eye fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody:margin-left-none:margin-right-none'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       STEP_NO,',
'       ACTION_REQUIRED,',
'       pc.USER_NAME,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       APPROVAL_TYPE,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                   ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'                ',
'            else  ',
'                    ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(pc.user_name) ',
'                   ',
'           end Photo',
'  from hrss_expense_report_approval_history  pc,  dct_employees_list2  e',
'  where pc.user_name = e.user_name (+)',
'and  REQUEST_ID = :P32_EXPENSE_REPORT_ID',
'order by STEP_NO , ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from hrss_expense_report_approval_history',
'where REQUEST_ID = :P32_EXPENSE_REPORT_ID'))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approval History'
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
 p_id=>wwv_flow_api.id(58172480236005903)
,p_max_row_count=>'1000000'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>60162518563069667
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4634123827566135)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4634554799566135)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4634941159566135)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4636472649566136)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4636895754566136)
,p_db_column_name=>'USER_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4637329780566137)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4637759565566137)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4638114707566137)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4638497553566137)
,p_db_column_name=>'COMMENTS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4638936179566138)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4639323668566138)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4639676100566138)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4640158156566139)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4640477132566139)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4640871494566139)
,p_db_column_name=>'PHOTO'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(78656901282179755)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'66313'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:ACTION_REQUIRED:USER_NAME:STATUS:RECEVIED_DATE:ACTION_DATE:COMMENTS::PHOTO'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
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
 p_id=>wwv_flow_api.id(4641663987566140)
,p_report_id=>wwv_flow_api.id(78656901282179755)
,p_name=>'Current Status'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D4F7D4'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110598095539402282)
,p_plug_name=>'Full History Report'
,p_region_name=>'inside-page'
,p_region_template_options=>'#DEFAULT#:t-Region--hideShowIconsMath:is-collapsed:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8040898187175502)
,p_plug_display_sequence=>100
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ROWNUM,',
'    pc.id,',
'    pc.request_type,',
'    pc.request_id,',
'    pc.action_type,',
'    pc.created_by,',
'    pc.created_date,',
'    pc.updated_by,',
'    pc.updated_date,',
'        (select e.full_name_en',
'        from dct_employees_list2 e',
'        where e.user_name = pc.UPDATED_BY) Employee_name',
'  ,   case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'               ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(pc.created_by)',
'           end Photo',
'      ',
'FROM',
'    expense_report_all_actions pc , dct_employees_list2  e',
'where pc.created_by = e.user_name (+)',
'and request_id = :P32_EXPENSE_REPORT_ID',
'order by UPDATED_DATE desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P32_EXPENSE_REPORT_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Full History Report'
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
 p_id=>wwv_flow_api.id(110598129568402283)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>112588167895466047
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4642423172566141)
,p_db_column_name=>'ROWNUM'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'No.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4642828110566142)
,p_db_column_name=>'ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4643189014566142)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4643642278566142)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Request Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4644048681566142)
,p_db_column_name=>'ACTION_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Action Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4644439729566143)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4644840624566143)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4645172368566143)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4645584582566143)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4646004770566143)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4646449136566144)
,p_db_column_name=>'PHOTO'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(110779442343807471)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'66368'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ROWNUM:ACTION_TYPE:EMPLOYEE_NAME:UPDATED_BY:UPDATED_DATE::PHOTO'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4603543989566099)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(43864597620179845)
,p_button_name=>'Add_File'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add File'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:20:P20_EXPENSE_REPORT_ID:&P32_EXPENSE_REPORT_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4616696078566117)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(43875199948196124)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4617123688566117)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(43875199948196124)
,p_button_name=>'Approve'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-check-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4617558140566117)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(43875199948196124)
,p_button_name=>'Reject'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4750754684900544)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(42756267985634128)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Message'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::P21_EXPENSE_REPORT_ID:&P32_EXPENSE_REPORT_ID.'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4617924187566117)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(43875199948196124)
,p_button_name=>'Delegate'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.::P33_EXPENSE_REPORT_ID,P33_FROM_USER:&P32_EXPENSE_REPORT_ID.,&EMP_NUM.'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(4668536999566159)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(4668901392566160)
,p_branch_name=>'Stay in 3'
,p_branch_action=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.::P32_PETTY_CASH_ID:&P32_PETTY_CASH_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>11
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4670941431660445)
,p_name=>'P32_EXPENSE_REPORT_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_source=>'EXPENSE_REPORT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4671012416660446)
,p_name=>'P32_PETTY_CASH_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_source=>'PETTY_CASH_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4671130224660447)
,p_name=>'P32_EXPENSE_REPORT_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Expense Report Date:</span>'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'EXPENSE_REPORT_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4671226700660448)
,p_name=>'P32_PURPOSE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(6403632666706763)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_source=>'PURPOSE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4671276851660449)
,p_name=>'P32_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Approval Status:</span>'
,p_source=>'APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_tag_attributes=>'style="color:#33cc33"'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4671444625660450)
,p_name=>'P32_INVOICING_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_source=>'INVOICING_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4671529678660451)
,p_name=>'P32_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(6403632666706763)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_source=>'PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4671592356660452)
,p_name=>'P32_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Justification:</span>'
,p_source=>'JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4671734094660453)
,p_name=>'P32_COMMENT_TO_APPROVER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_prompt=>'Comment To Approver'
,p_source=>'COMMENT_TO_APPROVER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>5
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4671765901660454)
,p_name=>'P32_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(6403632666706763)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_prompt=>'Creation Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4671904617660455)
,p_name=>'P32_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(6403632666706763)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4672026861660456)
,p_name=>'P32_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(6403632666706763)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4672113984660457)
,p_name=>'P32_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(6403632666706763)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_prompt=>'Updated Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4672220790660458)
,p_name=>'P32_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(6403632666706763)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_source=>'YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4672336455660459)
,p_name=>'P32_EXPENSE_REPORT_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Expense Report# :</span>'
,p_source=>'EXPENSE_REPORT_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4672452855660460)
,p_name=>'P32_PAID_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_source=>'PAID_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4672561527660461)
,p_name=>'P32_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(6403402786706761)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_source=>'TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4672658182660462)
,p_name=>'P32_EMP_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(6403632666706763)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_source=>'EMP_ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4672758573660463)
,p_name=>'P32_EMPLOYEE_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(6403632666706763)
,p_item_source_plug_id=>wwv_flow_api.id(4670704918660443)
,p_source=>'EMPLOYEE_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4672789086660464)
,p_name=>'P32_EMP_NAME'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_prompt=>'Employee'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.full_name_en',
'from employees_v e',
'where e.employee_num = :P32_EMPLOYEE_NUM'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118738374175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4672955790660465)
,p_name=>'P32_PRIORITY_NAME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Priority:</span>'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select decode(:P32_PRIORITY , ''L'' , ''Low'' , ''M'' , ''Medium'' , ''H'' ,''High'') priority',
'from dual'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4673028163660466)
,p_name=>'P32_TYPE_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Expense Report Type:</span>'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select decode(:P32_TYPE , ''C'' , ''Clearing'' , ''R'' , ''Reimbursement'') E_Type',
'from dual'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4673115210660467)
,p_name=>'P32_ORGANIZATION_NAME'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.org_name',
'from employees_v e',
'where e.employee_num = :P32_EMPLOYEE_NUM'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4673174496660468)
,p_name=>'P32_PETTY_CASH_NUM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(6403402786706761)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Petty Cash#:</span>'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select pc.petty_cash_no',
'from hrss_petty_cash pc',
'where pc.petty_cash_id = :P32_PETTY_CASH_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4673313684660469)
,p_name=>'P32_PETTY_CASH_AMOUNT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(6403402786706761)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Petty Cash Amount:</span>'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(l.receipt_amount),0)',
'from hrss_expense_report_lines l',
'where l.expense_report_id in (select er.expense_report_id',
'                                from hrss_expense_reports er',
'                                where er.petty_cash_id = :P32_PETTY_CASH_ID',
'                                and er.approval_status = ''Approved'');'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6403516190706762)
,p_name=>'P32_IMAGE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_prompt=>'Image'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                 ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'           end  Photo',
'from dct_employees_list2  e',
'where e.employee_num = :P32_EMPLOYEE_NUM'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_IMAGE'
,p_tag_attributes=>'style="border-radius: 50%;display: block;margin-right: auto;width: 40%;"'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(8118738374175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'URL'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6473344822568056)
,p_name=>'P32_PETTY_CASH_CLEARED'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(6403402786706761)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Cleared Amount:</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6477586319584329)
,p_name=>'P32_PETTY_CASH_TYPE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(6403402786706761)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6477961237591009)
,p_name=>'P32_PETTY_CASH_REIMBURSEMENT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(6403402786706761)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Reimbursement Amount:</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6478162266592996)
,p_name=>'P32_PETTY_CASH_REMAINING'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(6403402786706761)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Remaining Amount:</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6478544939594923)
,p_name=>'P32_PETTY_CASH_PROJECT'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(6403402786706761)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Project:</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6478793815596997)
,p_name=>'P32_PETTY_CASH_TASK'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(6403402786706761)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Task:</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6479092004599083)
,p_name=>'P32_PETTY_CASH_GL'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(6403402786706761)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">GL Account:</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6651442031135462)
,p_name=>'P32_TOTAL_AMOUNT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(sum(nvl(receipt_amount,0)),''99,999,999.99'')|| '' AED'' amount',
' from hrss_expense_report_lines',
' WHERE expense_report_id = :P32_EXPENSE_REPORT_ID;'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Total Amount:</span>'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(sum(nvl(receipt_amount,0)),''99,999,999.99'')|| '' AED'' amount',
' from hrss_expense_report_lines',
' WHERE expense_report_id = :P32_EXPENSE_REPORT_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_tag_attributes=>'style="color:#33cc33"'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6651526481135463)
,p_name=>'P32_CREATED_VIEW'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_prompt=>'Created View'
,p_source=>'''Created on: '' || :P32_CREATION_DATE || '' - By: '' || :P32_CREATED_BY'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="border: 1px solid powderblue;padding: 2px;"'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(8118738374175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6651629092135464)
,p_name=>'P32_UPDATED_VIEW'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(6403317518706760)
,p_prompt=>'Updated View'
,p_source=>'''Updated on: '' || :P32_UPDATED_DATE || '' - By: '' || :P32_UPDATED_BY'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="border: 1px solid powderblue;padding: 2px;"'
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(8118738374175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4657568444566154)
,p_name=>'set approve color'
,p_event_sequence=>30
,p_condition_element=>'P32_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Approved'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4658140174566154)
,p_event_id=>wwv_flow_api.id(4657568444566154)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'green'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4658572881566154)
,p_event_id=>wwv_flow_api.id(4657568444566154)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_APPROVAL_STATUS'
,p_attribute_01=>'font-weight'
,p_attribute_02=>'bold'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4658963520566154)
,p_name=>'set rejected color'
,p_event_sequence=>40
,p_condition_element=>'P32_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Rejected'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4659518966566154)
,p_event_id=>wwv_flow_api.id(4658963520566154)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'red'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4660008585566155)
,p_event_id=>wwv_flow_api.id(4658963520566154)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_APPROVAL_STATUS'
,p_attribute_01=>'font-weight'
,p_attribute_02=>'bolder'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4660398117566155)
,p_name=>'set in-Progress color'
,p_event_sequence=>50
,p_condition_element=>'P32_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'In-Progress'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4660932518566155)
,p_event_id=>wwv_flow_api.id(4660398117566155)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'GoldenRod'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4661380508566155)
,p_event_id=>wwv_flow_api.id(4660398117566155)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_APPROVAL_STATUS'
,p_attribute_01=>'font-weight'
,p_attribute_02=>'bolder'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4661812028566156)
,p_name=>'In-Progress'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P32_APPROVAL_STATUS'
,p_condition_element=>'P32_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'In-progress'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4662335954566156)
,p_event_id=>wwv_flow_api.id(4661812028566156)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_APPROVAL_STATUS'
,p_attribute_01=>'font-color'
,p_attribute_02=>'blue'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4662707981566156)
,p_name=>'Approve DA'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4617123688566117)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4663252785566156)
,p_event_id=>wwv_flow_api.id(4662707981566156)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to approve ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4663748662566157)
,p_event_id=>wwv_flow_api.id(4662707981566156)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'EXPENSE_REPORT_WORKFLOW.approve(:P32_EXPENSE_REPORT_ID , :APP_USER);',
'',
'',
'end;'))
,p_attribute_02=>'P32_EXPENSE_REPORT_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4664231612566157)
,p_event_id=>wwv_flow_api.id(4662707981566156)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Approved Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4664680549566157)
,p_event_id=>wwv_flow_api.id(4662707981566156)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4665072752566157)
,p_name=>'Reject DA'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4617558140566117)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4665631485566157)
,p_event_id=>wwv_flow_api.id(4665072752566157)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Are you sure to Reject ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4666079575566158)
,p_event_id=>wwv_flow_api.id(4665072752566157)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'EXPENSE_REPORT_WORKFLOW.reject(:P32_EXPENSE_REPORT_ID , :APP_USER);',
'',
'',
'end;'))
,p_attribute_02=>'P32_EXPENSE_REPORT_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4666628717566158)
,p_event_id=>wwv_flow_api.id(4665072752566157)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Rejected Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4667115457566158)
,p_event_id=>wwv_flow_api.id(4665072752566157)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4583534048120847)
,p_name=>'Dialog Close Message'
,p_event_sequence=>100
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(51387002248190091)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4583572584120848)
,p_event_id=>wwv_flow_api.id(4583534048120847)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(51387002248190091)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4583669129120849)
,p_name=>'Dialog Close Add'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4750754684900544)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4583792865120850)
,p_event_id=>wwv_flow_api.id(4583669129120849)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(51387002248190091)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6403746394706764)
,p_name=>'get Petty Cash Details'
,p_event_sequence=>120
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6403849521706765)
,p_event_id=>wwv_flow_api.id(6403746394706764)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_PETTY_CASH_TYPE,P32_PETTY_CASH_AMOUNT,P32_PETTY_CASH_REMAINING,P32_PETTY_CASH_PROJECT,P32_PETTY_CASH_TASK,P32_PETTY_CASH_GL,P32_PETTY_CASH_CLEARED,P32_PETTY_CASH_REIMBURSEMENT'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select petty_cash_type_code , to_char(nvl(amount,0),''99,999,999.99'') amount ',
'    , to_char(nvl((amount - cleared_amount),0) ,''99,999,999.99'') remaining ',
'    , project_number , task , gl_account ',
'    , to_char(nvl(cleared_amount,0),''99,999,999.99'')    cleared_amount',
'    , to_char(nvl(reimburacement_amount,0),''99,999,999.99'')  reimburacement_amount',
'from petty_cash_all_v',
'where petty_cash_id = :P32_PETTY_CASH_ID;'))
,p_attribute_07=>'P32_PETTY_CASH_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6403938391706766)
,p_name=>'Dialog Close IE Doc Add'
,p_event_sequence=>130
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4603543989566099)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6404020511706767)
,p_event_id=>wwv_flow_api.id(6403938391706766)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(43864734773179846)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6404116281706768)
,p_name=>'Dialog Close IE Docs Updates'
,p_event_sequence=>140
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(43864734773179846)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6404170627706769)
,p_event_id=>wwv_flow_api.id(6404116281706768)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(43864734773179846)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(4670774513660444)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(4670704918660443)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Expense Report Approve / Rejects'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
