prompt --application/pages/page_00053
begin
--   Manifest
--     PAGE: 00053
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
 p_id=>53
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Approval Monitoring - Admin'
,p_alias=>'APPROVAL-MONITORING-ADMIN'
,p_step_title=>'Approval Monitoring - Admin'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9025'
,p_last_upd_yyyymmddhh24miss=>'20220204063856'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(245557422419008)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(244941587419010)
,p_plug_name=>'Approval Monitoring - Admin'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:js-showMaximizeButton:t-Form--large'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select request,ID, REQUEST_ID, Requestor_employee_num,Requestor_employee_name,Requestor_Photo ,REQUEST_NUMBER, AMOUNT, REQUEST_DATE, REQUEST_TYPE',
'    , STEP_NO, approver_user_name ,approver_Photo,  approver_Full_name, STATUS, RECEVIED_DATE, ACTION_DATE, approver_Emp_num',
'from (SELECT',
'    ''Petty cash''            request,',
'    id,',
'    request_id,',
'    pc.employee_num         Requestor_employee_num,',
'    e1.full_name_en         Requestor_employee_name,',
'     case nvl(dbms_lob.getlength(e1.photo_blob),0) ',
'           when 0  THEN',
'                 ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e1.user_name)',
'           end Requestor_Photo,',
'    pc.petty_cash_no        request_number,',
'    pc.amount,',
'    pc.petty_cash_date      request_date,',
'    decode(pc.petty_cash_type,''P'',''Permenant'',''T'',''Temporary'')      request_type,',
'    h.step_no,',
'    h.user_name     approver_user_name,',
'    ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(h.user_name)',
'     approver_Photo,',
'    (select e.full_name_en ',
'     from employees_v e',
'     where e.user_name = h.user_name) approver_Full_name,',
'    h.status,',
'    h.recevied_date,',
'    h.action_date,',
'    h.employee_num                  approver_Emp_num',
'FROM',
'    hrss_approval_history h , hrss_petty_cash pc, employees_v e1',
'where h.request_id = pc.petty_cash_id (+)',
'and pc.employee_num = e1.employee_num',
'--order by h.request_id , h.step_no ,h.id',
'union all',
'',
'',
'',
'SELECT',
'    ''Expense report''    Request,',
'    id,',
'    request_id,',
'    er.employee_num                 Requestor_employee_num,',
'    e1.full_name_en                 Requestor_employee_name,',
'      case nvl(dbms_lob.getlength(e1.photo_blob),0) ',
'           when 0  THEN',
'                 ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e1.user_name)',
'           end Requestor_Photo,',
'    er.expense_report_num               request_number,',
'    (select nvl(sum(l.receipt_amount),0)',
'    from hrss_expense_report_lines  l',
'    where l.expense_report_id = er.expense_report_id) Amount,',
'    er.expense_report_date  request_date,',
'    decode(er.type,''R'',''Reimbursement'',''C'',''Clearing'')                 request_type,',
'    h.step_no,',
'    h.user_name     approver_user_name,',
'     ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(h.user_name)',
'     approver_Photo,',
'    (select e.full_name_en ',
'     from employees_v e',
'     where e.user_name = h.user_name) approver_Full_name,',
'    h.status,',
'    h.recevied_date,',
'    h.action_date,',
'    h.employee_num          approver_Emp_num',
'FROM',
'    hrss_expense_report_approval_history h , hrss_expense_reports er, employees_v e1',
'where h.request_id = er.expense_report_id (+)',
'and er.employee_num = e1.employee_num',
'--order by h.request_id , h.step_no ,h.id;',
'    )',
'-- order by request_id desc , step_no ,id   '))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Approval Monitoring - Admin'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(244816105419010)
,p_name=>'Approval Monitoring - Admin'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>32447282131043504
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(244468140419014)
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
 p_id=>wwv_flow_api.id(244041581419015)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(517912942973687)
,p_db_column_name=>'REQUESTOR_PHOTO'
,p_display_order=>12
,p_column_identifier=>'Q'
,p_column_label=>'Requestor'
,p_column_html_expression=>'<img src="#REQUESTOR_PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(517774232973685)
,p_db_column_name=>'REQUESTOR_EMPLOYEE_NUM'
,p_display_order=>22
,p_column_identifier=>'S'
,p_column_label=>'Requestor#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(517648024973684)
,p_db_column_name=>'REQUESTOR_EMPLOYEE_NAME'
,p_display_order=>32
,p_column_identifier=>'T'
,p_column_label=>'Requestor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(518331725973691)
,p_db_column_name=>'REQUEST'
,p_display_order=>42
,p_column_identifier=>'O'
,p_column_label=>'Request'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(242433250419016)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>52
,p_column_identifier=>'F'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(242845482419016)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>62
,p_column_identifier=>'E'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(243253432419015)
,p_db_column_name=>'AMOUNT'
,p_display_order=>72
,p_column_identifier=>'D'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(242055077419016)
,p_db_column_name=>'STEP_NO'
,p_display_order=>82
,p_column_identifier=>'G'
,p_column_label=>'Step'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(240472752419017)
,p_db_column_name=>'STATUS'
,p_display_order=>102
,p_column_identifier=>'K'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(240084822419018)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>112
,p_column_identifier=>'L'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(239628233419018)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>122
,p_column_identifier=>'M'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(517844047973686)
,p_db_column_name=>'APPROVER_PHOTO'
,p_display_order=>142
,p_column_identifier=>'R'
,p_column_label=>'Approver'
,p_column_html_expression=>'<img src="#APPROVER_PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(517589775973683)
,p_db_column_name=>'APPROVER_USER_NAME'
,p_display_order=>152
,p_column_identifier=>'U'
,p_column_label=>'Approver User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(517456010973682)
,p_db_column_name=>'APPROVER_FULL_NAME'
,p_display_order=>162
,p_column_identifier=>'V'
,p_column_label=>'Approver Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(517347216973681)
,p_db_column_name=>'REQUEST_NUMBER'
,p_display_order=>172
,p_column_identifier=>'W'
,p_column_label=>'Request Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(517284121973680)
,p_db_column_name=>'APPROVER_EMP_NUM'
,p_display_order=>182
,p_column_identifier=>'X'
,p_column_label=>'Approver Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(238661420420823)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'324535'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUESTOR_PHOTO:REQUESTOR_EMPLOYEE_NUM:REQUESTOR_EMPLOYEE_NAME:REQUEST_NUMBER:REQUEST_TYPE:REQUEST_DATE:AMOUNT:STEP_NO:RECEVIED_DATE:ACTION_DATE:APPROVER_FULL_NAME:STATUS:APPROVER_PHOTO'
,p_sort_column_1=>'REQUEST_NUMBER'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'STEP_NO'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'ID'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_break_on=>'0:0:0:0:0'
,p_break_enabled_on=>'0:0:0:0:0'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(24687583469097277)
,p_report_id=>wwv_flow_api.id(238661420420823)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(24687962504097277)
,p_report_id=>wwv_flow_api.id(238661420420823)
,p_name=>'Pending'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#E9F246'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(24688308527097278)
,p_report_id=>wwv_flow_api.id(238661420420823)
,p_name=>'Reject'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.component_end;
end;
/
