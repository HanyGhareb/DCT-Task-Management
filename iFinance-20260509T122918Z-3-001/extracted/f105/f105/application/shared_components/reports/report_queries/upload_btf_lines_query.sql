prompt --application/shared_components/reports/report_queries/upload_btf_lines_query
begin
--   Manifest
--     WEB SERVICE: upload_btf_lines_query
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(97239538466971084)
,p_name=>'upload_btf_lines_query'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LINE_TYEP, PROJECT_NUMBER, TASK_NUMBER, COST_CENTER, EXPENDITURE_TYPE, BUDGET, ACTUAL, ENCUMBERANCE, FUND_AVAILABLE',
'From',
'(',
'-- get From Lines with fund available > 0',
'select ''FROM'' line_tyep,PROJECT_NUMBER, TASK_NUMBER, COST_CENTER, EXPENDITURE_TYPE, BUDGET, ACTUAL, ENCUMBERANCE, FUND_AVAILABLE    --, ACCOUNTING_YEAR ',
'from project_balances',
'where ACCOUNTING_YEAR = :ACCOUNTING_YEAR',
'and FUND_AVAILABLE > 0',
'and project_number In (',
'',
'select DISTINCT',
'       ENTITY_NAME',
'  from BTF_DATA_ACCESS_REQUESTS',
' where person_id = :PERSON_ID',
' and REQUEST_STATUS in (''Auto-Approved'' , ''Approved'')',
' and sysdate BETWEEN NVL(start_date , sysdate -10) and NVL(End_date , sysdate +10))',
'-- order by project_number , task_number , expenditure_type',
'-- ;',
' ',
'UNION  ',
' ',
' ',
'-- get Addition Lines for all Years',
'select ''TO'' line_tyep,PROJECT_NUMBER, TASK_NUMBER, COST_CENTER, EXPENDITURE_TYPE, BUDGET, ACTUAL, ENCUMBERANCE,  FUND_AVAILABLE',
'from',
'(',
'select distinct PROJECT_NUMBER, TASK_NUMBER, COST_CENTER, EXPENDITURE_TYPE --, BUDGET, ACTUAL, ENCUMBERANCE, FUND_AVAILABLE, ACCOUNTING_YEAR ',
'        ,(select b.budget from project_balances b',
'          where b.project_number = pb.project_number',
'          and   b.task_number = pb.task_number',
'          and   b.expenditure_type = pb.expenditure_type',
'          and   b.cost_center  = pb.cost_center',
'          and   b.accounting_year = 2022) budget',
'        ,(select b.encumberance from project_balances b',
'          where b.project_number = pb.project_number',
'          and   b.task_number = pb.task_number',
'          and   b.expenditure_type = pb.expenditure_type',
'          and   b.cost_center  = pb.cost_center',
'          and   b.accounting_year = 2022) ENCUMBERANCE',
'        ,(select b.actual from project_balances b',
'          where b.project_number = pb.project_number',
'          and   b.task_number = pb.task_number',
'          and   b.expenditure_type = pb.expenditure_type',
'          and   b.cost_center  = pb.cost_center',
'          and   b.accounting_year = 2022) actual',
'        ,(select b.fund_available from project_balances b',
'          where b.project_number = pb.project_number',
'          and   b.task_number = pb.task_number',
'          and   b.expenditure_type = pb.expenditure_type',
'          and   b.cost_center  = pb.cost_center',
'          and   b.accounting_year = 2022) fund_available',
'from project_balances pb',
'where project_number In (',
'',
'select DISTINCT',
'       ENTITY_NAME',
'  from BTF_DATA_ACCESS_REQUESTS',
' where person_id = :PERSON_ID',
' and REQUEST_STATUS in (''Auto-Approved'' , ''Approved'')',
' and sysdate BETWEEN NVL(start_date , sysdate -10) and NVL(End_date , sysdate +10))',
'-- order by project_number , task_number , expenditure_type',
' )',
' )',
' ORDER by LINE_TYEP, PROJECT_NUMBER, TASK_NUMBER, COST_CENTER, EXPENDITURE_TYPE; '))
,p_xml_structure=>'APEX'
,p_report_layout_id=>wwv_flow_api.id(97238992194114108)
,p_format=>'XLS'
,p_output_file_name=>'upload_btf_lines_query'
,p_content_disposition=>'ATTACHMENT'
,p_xml_items=>'CURRENT_YEAR:PERSON_ID'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(97189055786717433)
,p_shared_query_id=>wwv_flow_api.id(97239538466971084)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LINE_TYEP, PROJECT_NUMBER, TASK_NUMBER, COST_CENTER, EXPENDITURE_TYPE, BUDGET, ACTUAL, ENCUMBERANCE, FUND_AVAILABLE',
'From',
'(',
'-- get From Lines with fund available > 0',
'select ''FROM'' line_tyep,PROJECT_NUMBER, TASK_NUMBER, COST_CENTER, EXPENDITURE_TYPE, BUDGET, ACTUAL, ENCUMBERANCE, FUND_AVAILABLE    --, ACCOUNTING_YEAR ',
'from project_balances',
'where ACCOUNTING_YEAR = :CURRENT_YEAR',
'and FUND_AVAILABLE > 0',
'and project_number In (',
'',
'select DISTINCT',
'       ENTITY_NAME',
'  from BTF_DATA_ACCESS_REQUESTS',
' where person_id = :PERSON_ID',
' and REQUEST_STATUS in (''Auto-Approved'' , ''Approved'')',
' and sysdate BETWEEN NVL(start_date , sysdate -10) and NVL(End_date , sysdate +10))',
'-- order by project_number , task_number , expenditure_type',
'-- ;',
' ',
'UNION  ',
' ',
' ',
'-- get Addition Lines for all Years',
'select ''TO'' line_tyep,PROJECT_NUMBER, TASK_NUMBER, COST_CENTER, EXPENDITURE_TYPE, BUDGET, ACTUAL, ENCUMBERANCE,  FUND_AVAILABLE',
'from',
'(',
'select distinct PROJECT_NUMBER, TASK_NUMBER, COST_CENTER, EXPENDITURE_TYPE --, BUDGET, ACTUAL, ENCUMBERANCE, FUND_AVAILABLE, ACCOUNTING_YEAR ',
'        ,(select b.budget from project_balances b',
'          where b.project_number = pb.project_number',
'          and   b.task_number = pb.task_number',
'          and   b.expenditure_type = pb.expenditure_type',
'          and   b.cost_center  = pb.cost_center',
'          and   b.accounting_year = :CURRENT_YEAR) budget',
'        ,(select b.encumberance from project_balances b',
'          where b.project_number = pb.project_number',
'          and   b.task_number = pb.task_number',
'          and   b.expenditure_type = pb.expenditure_type',
'          and   b.cost_center  = pb.cost_center',
'          and   b.accounting_year = :CURRENT_YEAR) ENCUMBERANCE',
'        ,(select b.actual from project_balances b',
'          where b.project_number = pb.project_number',
'          and   b.task_number = pb.task_number',
'          and   b.expenditure_type = pb.expenditure_type',
'          and   b.cost_center  = pb.cost_center',
'          and   b.accounting_year = :CURRENT_YEAR) actual',
'        ,(select b.fund_available from project_balances b',
'          where b.project_number = pb.project_number',
'          and   b.task_number = pb.task_number',
'          and   b.expenditure_type = pb.expenditure_type',
'          and   b.cost_center  = pb.cost_center',
'          and   b.accounting_year = :CURRENT_YEAR) fund_available',
'from project_balances pb',
'where project_number In (',
'',
'select DISTINCT',
'       ENTITY_NAME',
'  from BTF_DATA_ACCESS_REQUESTS',
' where person_id = :PERSON_ID',
' and REQUEST_STATUS in (''Auto-Approved'' , ''Approved'')',
' and sysdate BETWEEN NVL(start_date , sysdate -10) and NVL(End_date , sysdate +10))',
'-- order by project_number , task_number , expenditure_type',
' )',
' )',
' ORDER by LINE_TYEP, PROJECT_NUMBER, TASK_NUMBER, COST_CENTER, EXPENDITURE_TYPE; '))
);
wwv_flow_api.component_end;
end;
/
