prompt --application/pages/page_00056
begin
--   Manifest
--     PAGE: 00056
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
 p_id=>56
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty Cash - Change Type'
,p_alias=>'PETTY-CASH-CHANGE-TYPE'
,p_step_title=>'Petty Cash - Change Type'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Scroll Results Only in Side Column */',
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
'background-color:#0e6655;',
' ',
'}',
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
'     background-color: #f3f0ef;',
'    color:#000;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20211214125614'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(79832475752248194)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(80071936831446634)
,p_plug_name=>'Petty Cash Report'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PETTY_CASH_ID, PETTY_CASH_NO, PETTY_CASH_DATE, DUE_DATE, PETTY_CASH_TYPE, EMPLOYEE_NUM, EMPLOYEE, EMPLOYEE_SECTOR, EMPLOYEE_DEPARTMENT, PROJECT_NUMBER, PROJECT_NAME, ',
'        PROJECT_SECTOR, PROJECT_DEPARTMENT, TASK, AMOUNT, nvl(CLEARED_AMOUNT,0) CLEARED_AMOUNT, nvl(REIMBURACEMENT_AMOUNT, 0) REIMBURACEMENT_AMOUNT, ',
'        nvl((AMOUNT - CLEARED_AMOUNT),0) Outstanding_Amount,',
'        PURPOSE, CLOSING_DATE,APPROVAL_STATUS, STATUS, STATUS_COLOR, RECONCILED_DATE, PRIORITY, CREATION_DATE, CREATED_BY, UPDATED_BY, UPDATED_DATE, YEAR, ',
'        GL_ACCOUNT, JUSTIFICATION, COMMENT_TO_APPROVER, PHOTO, ''<span class="fa fa-exchange" aria-hidden="true"></span>'' "Change Type"',
'from (select pc.PETTY_CASH_ID,',
'       pc.PETTY_CASH_NO,',
'       pc.PETTY_CASH_DATE,',
'       pc.DUE_DATE,',
'       pc.PETTY_CASH_TYPE,',
'       pc.EMPLOYEE_NUM,',
'       e.full_name_en       EMPLOYEE,',
'       e.sector             Employee_sector,',
'       e.department_name    Employee_department,',
'       pc.PROJECT_NUMBER,',
'       (select DISTINCT f.project_name',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number',
'        and ROWNUM = 1) Project_name,',
'      (select DISTINCT f.tca_sector',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number',
'        and ROWNUM = 1) Project_Sector,',
'      (select DISTINCT f.department',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number',
'        and ROWNUM = 1) Project_Department,  ',
'       TASK,',
'       AMOUNT,',
'       (select sum(nvl(l.receipt_amount,0))',
'        from hrss_expense_report_lines l',
'        where l.expense_report_id in (select er.expense_report_id',
'                                        from hrss_expense_reports er',
'                                        where er.petty_cash_id = pc.petty_cash_id',
'                                        and er.type = ''C''',
'                                        and er.approval_status = ''Approved'')) Cleared_amount,',
'    (select sum(nvl(l.receipt_amount,0))',
'        from hrss_expense_report_lines l',
'        where l.expense_report_id in (select er.expense_report_id',
'                                        from hrss_expense_reports er',
'                                        where er.petty_cash_id = pc.petty_cash_id',
'                                        and er.type = ''R''',
'                                        and er.approval_status = ''Approved'')) Reimburacement_amount,    ',
'       pc.PURPOSE,',
'       pc.CLOSING_DATE,',
'       pc.APPROVAL_STATUS,',
'       pc.STATUS,',
'       case pc.approval_status',
'        WHEN    ''Approved''  THEN ''green''',
'        WHEN    ''Rejected''   Then  ''red''',
'        When    ''In-Progress''   Then ''GoldenRod''',
'        ELSE    ''black''',
'       end    as  "STATUS_COLOR",',
'       pc.RECONCILED_DATE,',
'       pc.PRIORITY,',
'       pc.CREATION_DATE,',
'       pc.CREATED_BY,',
'       pc.UPDATED_BY,',
'       pc.UPDATED_DATE,',
'       pc.YEAR,',
'       pc.GL_ACCOUNT,',
'       pc.JUSTIFICATION,',
'       pc.COMMENT_TO_APPROVER,',
'          case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end PHOTO',
'      ',
'  from HRSS_PETTY_CASH pc , employees_v e',
'  where pc.employee_num = e.employee_num',
'  and pc.APPROVAL_STATUS = NVL(:P56_APPROVAL_STATUS , pc.APPROVAL_STATUS)',
'--  and pc.petty_cash_id not in (select distinct REQUEST_ID',
'--from HRSS_approval_history)',
'     );'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P56_APPROVAL_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Petty Cash Report'
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
 p_id=>wwv_flow_api.id(80072019229446635)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_PETTY_CASH_ID,P3_ID:#PETTY_CASH_ID#,#PETTY_CASH_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>148057518876848904
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25699448220395951)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25699055071395950)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25698696828395949)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25698293719395949)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25697836931395948)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8333351243197780)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25697457798395948)
,p_db_column_name=>'EMPLOYEE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Employee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25697079616395947)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25696662479395947)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25696296393395946)
,p_db_column_name=>'TASK'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25695844071395945)
,p_db_column_name=>'AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25695421117395945)
,p_db_column_name=>'PURPOSE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8345862665015663)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25695066225395944)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25694688042395944)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Approval Status'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span style="font-weight:bold;color:#STATUS_COLOR#">#APPROVAL_STATUS#</span>',
''))
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25694231784395943)
,p_db_column_name=>'STATUS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25693830507395943)
,p_db_column_name=>'RECONCILED_DATE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Reconciled Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25693473151395941)
,p_db_column_name=>'PRIORITY'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25693083556395940)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25692694463395940)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25692268180395939)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25691819817395939)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25691454551395938)
,p_db_column_name=>'YEAR'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25691057227395938)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25690656230395937)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25690254680395936)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25689825693395936)
,p_db_column_name=>'PHOTO'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25689468485395935)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25702690007395956)
,p_db_column_name=>'EMPLOYEE_DEPARTMENT'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Employee Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25702205401395955)
,p_db_column_name=>'EMPLOYEE_SECTOR'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Employee Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25701836727395954)
,p_db_column_name=>'PROJECT_SECTOR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Project Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25701469065395954)
,p_db_column_name=>'PROJECT_DEPARTMENT'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Project Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25701044133395953)
,p_db_column_name=>'CLEARED_AMOUNT'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Cleared Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25700612088395952)
,p_db_column_name=>'REIMBURACEMENT_AMOUNT'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Reimburacement Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25700281501395952)
,p_db_column_name=>'STATUS_COLOR'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25699819334395951)
,p_db_column_name=>'OUTSTANDING_AMOUNT'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Outstanding Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25849202834265845)
,p_db_column_name=>'Change Type'
,p_display_order=>390
,p_column_identifier=>'AN'
,p_column_label=>'Change Type'
,p_column_link=>'f?p=&APP_ID.:60:&SESSION.::&DEBUG.:60:P60_ID,P60_TYPE,P60_NAME:#PETTY_CASH_ID#,#PETTY_CASH_TYPE#,#EMPLOYEE#'
,p_column_linktext=>'#Change Type#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(80098623526411807)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'422964'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE:EMPLOYEE_NUM:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:AMOUNT:CLEARED_AMOUNT:REIMBURACEMENT_AMOUNT:OUTSTANDING_AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO::Change Type'
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
 p_id=>wwv_flow_api.id(25688686430395933)
,p_report_id=>wwv_flow_api.id(80098623526411807)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'OUTSTANDING_AMOUNT'
,p_operator=>'<'
,p_expr=>'0'
,p_condition_sql=>' (case when ("OUTSTANDING_AMOUNT" < to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# < #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25703348071395958)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(79832475752248194)
,p_button_name=>'Print'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Print'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:0:&SESSION.:PRINT_REPORT=ExpenseReportDetails3:&DEBUG.:::'
,p_button_condition=>'EMP_NUM'
,p_button_condition2=>'9051'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25688215373395932)
,p_name=>'P56_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(80071936831446634)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25687861599395931)
,p_name=>'P56_APPROVAL_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(80071936831446634)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25687473606395931)
,p_name=>'P56_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(80071936831446634)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25848317536265836)
,p_name=>'Dialog Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(80071936831446634)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25848233852265835)
,p_event_id=>wwv_flow_api.id(25848317536265836)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(80071936831446634)
);
wwv_flow_api.component_end;
end;
/
