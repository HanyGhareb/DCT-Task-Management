prompt --application/shared_components/reports/report_queries/expensereportdetails
begin
--   Manifest
--     WEB SERVICE: ExpenseReportDetails
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(7461380139250875)
,p_name=>'ExpenseReportDetails'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select expense_report_id , expense_report_num , expense_report_amount , expense_report_approval_status , expense_report_date',
'        , expense_report_emp_name , expense_report_emp_num, expense_report_justification',
'from expense_reports_all_v',
'where expense_report_id = 9;'))
,p_report_layout_id=>wwv_flow_api.id(7463670001435067)
,p_format=>'PDF'
,p_output_file_name=>'ExpenseReportDetails'
,p_content_disposition=>'INLINE'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(7466865844649676)
,p_shared_query_id=>wwv_flow_api.id(7461380139250875)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select expense_report_id , expense_report_num , expense_report_amount , expense_report_approval_status , expense_report_date',
'        , expense_report_emp_name , expense_report_emp_num, expense_report_justification',
'from expense_reports_all_v',
'where expense_report_id = 9;'))
);
wwv_flow_api.component_end;
end;
/
