prompt --application/shared_components/reports/report_queries/expensereportdetails4
begin
--   Manifest
--     WEB SERVICE: ExpenseReportDetails4
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
 p_id=>wwv_flow_api.id(7494780981027230)
,p_name=>'ExpenseReportDetails4'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ie.expense_report_num , ie.expense_report_date , ie.expense_report_amount',
'       , ie.expense_report_approval_status , ie.expense_report_emp_name, ie.expense_report_emp_num',
'       , ie.expense_report_justification ,ie.expense_report_type',
'    -- Petty Cash Details',
'       , ie.petty_cash_no , ie.petty_cash_amount, ie.petty_cash_type',
'    -- Projects Details',
'       , ie.project_number , ie.task , ie.cost_center_code, ie.gl_account, ie.gl_account_name',
'    -- Sector Details',
'       , ie.employee_sector  , ie.employee_department',
'    -- Approver Details',
'       , h.step_no, h.employee_num , h.user_name, h.recevied_date, h.action_date, h.status, e.full_name_en approver_name',
'       , ifinance_users.pdf2img(e.photo_blob) photo',
'from expense_reports_all_v ie, hrss_expense_report_approval_history h , employees_v e',
'where ie.expense_report_id = h.request_id',
'and h.employee_num = e.employee_num',
'and ie.expense_report_id = :P35_ID'))
,p_format=>'PDF'
,p_output_file_name=>'ExpenseReportDetails4'
,p_content_disposition=>'ATTACHMENT'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(7497202083216363)
,p_shared_query_id=>wwv_flow_api.id(7494780981027230)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ie.expense_report_num , ie.expense_report_date , ie.expense_report_amount',
'       , ie.expense_report_approval_status , ie.expense_report_emp_name, ie.expense_report_emp_num',
'       , ie.expense_report_justification ,ie.expense_report_type',
'    -- Petty Cash Details',
'       , ie.petty_cash_no , ie.petty_cash_amount, ie.petty_cash_type',
'    -- Projects Details',
'       , ie.project_number , ie.task , ie.cost_center_code, ie.gl_account, ie.gl_account_name',
'    -- Sector Details',
'       , ie.employee_sector  , ie.employee_department',
'    -- Approver Details',
'       , h.step_no, h.employee_num , h.user_name, h.recevied_date, h.action_date, h.status, e.full_name_en approver_name',
'       , ifinance_users.pdf2img(e.photo_blob) photo',
'from expense_reports_all_v ie, hrss_expense_report_approval_history h , employees_v e',
'where ie.expense_report_id = h.request_id',
'and h.employee_num = e.employee_num',
'and ie.expense_report_id = :P35_ID'))
);
wwv_flow_api.component_end;
end;
/
