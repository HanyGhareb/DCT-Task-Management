prompt --application/shared_components/reports/report_queries/btf_end_user_query
begin
--   Manifest
--     WEB SERVICE: BTF_END_USER_QUERY
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
 p_id=>wwv_flow_api.id(1025068119518019)
,p_name=>'BTF_END_USER_QUERY'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_no                              request_no,',
'    trim(TO_CHAR( request_date, ''ddTH MONTH'')) ',
'    || '','' ',
'    ||extract(year from request_date)                request_date,',
'    to_char(required_date,''DD-MON-YYYY'')             required_date,  ',
'    request_status,',
'    justification,',
'    (select value',
'        from dct_lookup_values',
'        where value_id = priority)                  priority',
'FROM',
'    btf_end_users_header_v',
'WHERE',
'    request_id = 28 --:REQUEST_ID;'))
,p_xml_structure=>'APEX'
,p_report_layout_id=>wwv_flow_api.id(100890906966164429)
,p_format=>'PDF'
,p_output_file_name=>'BTF_END_USER_QUERY'
,p_content_disposition=>'INLINE'
,p_xml_items=>'REQUEST_ID'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(80754690021378084)
,p_shared_query_id=>wwv_flow_api.id(1025068119518019)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_no                              request_no,',
'    trim(TO_CHAR( request_date, ''ddTH MONTH'')) ',
'    || '','' ',
'    ||extract(year from request_date)                request_date,',
'    to_char(required_date,''DD-MON-YYYY'')             required_date,  ',
'    request_status,',
'    justification,',
'    (select value',
'        from dct_lookup_values',
'        where value_id = priority)                  priority',
'  , request_type ',
'  , case request_type',
'    when ''S'' then ''Standard''',
'    when ''C'' then ''Change Request''',
'    when ''A'' then ''Budget Addition''',
'    when ''R'' then ''Budget Release''',
'    end request_type_name',
'  , FROM_AMOUNT, TO_AMOUNT  ',
'FROM',
'    btf_end_users_header_v',
'WHERE',
'    request_id = nvl(:REQUEST_ID, :P8_REQUEST_ID);'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(80754514178378084)
,p_shared_query_id=>wwv_flow_api.id(1025068119518019)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    FROM_TO,',
'    line_no,',
'    project_number,',
'    (select p.project_name',
'     from project p',
'     where p.project_number = l.project_number) project_name,',
'    task_number,',
'    expenditure_type,',
'    cost_center,',
'    user_details.get_cost_center_name(COST_CENTER) Cost_Center_name,',
'    user_details.get_cc_department_name(cost_center)  department,',
'    user_details.get_cc_sector_name(cost_center)        sector,',
'    gl_account,',
'    future2,',
'    to_char(budget,''99,999,999,999.99'')                  budget,',
'    to_char(encumbrances, ''99,999,999,999.99'')          encumbrances,',
'    to_char(actual, ''99,999,999,999.99'')                actual,',
'    to_char(requested_amount,''99,999,999,999.99'')       requested_amount,',
'    to_char(fund_available, ''99,999,999,999.99'')        fund_available,',
'    case FROM_TO ',
'        when ''FROM'' ',
'            Then to_char((budget - encumbrances - actual -requested_amount), ''99,999,999,999.99'')        ',
'        when ''TO''',
'            Then  to_char((budget - encumbrances - actual + requested_amount), ''99,999,999,999.99'') ',
'    End Balance_after',
'FROM',
'    btf_end_users_lines l',
'where request_id = :request_id',
'order by FROM_TO , line_no;'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(80754304961378084)
,p_shared_query_id=>wwv_flow_api.id(1025068119518019)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'--    id,',
'--    request_id,',
'    step_no,',
'--    person_id,',
'    (SELECT initcap(e.full_name_en)',
'     FROM employees_v e',
'     WHERE e.person_id = h.person_id)    full_name,',
'    (SELECT r.role_name',
'     FROM roles r',
'     WHERE r.role_id = h.role_id)       role_name,',
'    action_required,',
'    to_char(recevied_date, ''DD-Mon-YYYY'')       recevied_date,',
'    status,',
'    to_char(action_date, ''DD-Mon-YYYY HH:MI'')         action_date,',
'    comments,',
'    CASE',
'        WHEN dbms_lob.getlength(( SELECT  s.signature_blob',
'                                    FROM dct_employees_signatures s',
'                                    WHERE s.person_id = h.person_id',
'                                    AND s.status = ''Y''',
'                                )) > 0 ',
'            THEN',
'                (SELECT  s.signature_clob',
'                  FROM dct_employees_signatures s',
'                  WHERE  s.person_id = h.person_id',
'                  AND s.status = ''Y'')',
'    END                                        AS signature',
'FROM',
'    btf_end_users_req_approval_history h',
'WHERE',
'        h.request_id = :request_id',
'    AND status NOT IN ( ''Bateen'' )',
'order by to_number(step_no)'))
);
wwv_flow_api.component_end;
end;
/
