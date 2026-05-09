prompt --application/shared_components/reports/report_queries/petty_cash_details
begin
--   Manifest
--     WEB SERVICE: Petty Cash Details
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
 p_id=>wwv_flow_api.id(7561556954387614)
,p_name=>'Petty Cash Details'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select pc.petty_cash_id , pc.petty_cash_no , pc.petty_cash_date , pc.petty_cash_type , pc.amount, pc.approval_status , pc.justification',
'      ,pc.employee_num , pc.emp_name , pc.org_name , pc.department_name , pc.sector',
'      , pc.cost_center_code , pc.gl_account , pc.project_number , pc.project_name , pc.task',
'      , a.step_no , a.recevied_date , a.action_date ,',
'      (select e.full_name_en from employees_v e where e.employee_num = a.employee_num) Approver_name',
'from petty_cash_all_v pc , hrss_approval_history a',
'where pc.petty_cash_id = a.request_id',
'and pc.petty_cash_id = :P35_PETTY_CASH_ID',
'order by a.step_no;'))
,p_report_layout_id=>wwv_flow_api.id(18285724233285929)
,p_format=>'PDF'
,p_output_file_name=>'Petty Cash Details'
,p_content_disposition=>'INLINE'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(18286155025287253)
,p_shared_query_id=>wwv_flow_api.id(7561556954387614)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select pc.petty_cash_id , pc.petty_cash_no , pc.petty_cash_date , pc.petty_cash_type , pc.amount, pc.approval_status , pc.justification',
'      ,pc.employee_num , pc.emp_name , pc.org_name , pc.department_name , pc.sector',
'      , pc.cost_center_code , pc.gl_account , pc.project_number , pc.project_name , pc.task',
'      , a.step_no , TO_CHAR(a.recevied_date, ''DD-MON-YYYY HH24:MI:SS'') recevied_date , TO_CHAR(a.action_date, ''DD-MON-YYYY HH24:MI:SS'')  action_date ,',
'      (select e.full_name_en from employees_v e where e.employee_num = a.employee_num) Approver_name',
'from petty_cash_all_v pc , hrss_approval_history a',
'where pc.petty_cash_id = a.request_id',
'and pc.petty_cash_id = :P3_ID',
'order by a.step_no;'))
);
wwv_flow_api.component_end;
end;
/
