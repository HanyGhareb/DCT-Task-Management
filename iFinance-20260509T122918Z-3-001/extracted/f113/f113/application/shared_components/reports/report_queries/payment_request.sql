prompt --application/shared_components/reports/report_queries/payment_request
begin
--   Manifest
--     WEB SERVICE: payment request 
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(3124507647621743)
,p_name=>'payment request '
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_number,',
'    request_date,',
'    (select v.vendor_name ',
'        from vendors v',
'        where v.vendor_number = pra.vendor_number',
'        and v.vendor_site_code =  pra.vendor_site_code',
'        and rownum = 1) Vendor_name,',
'    invoice_number,',
'    invoice_description,',
'    currency_code,',
'    invoice_amount,',
'    iban,',
'    completion_date',
'FROM',
'    payment_requests_all pra',
'WHERE',
'    payment_request_id = :P2_PAYMENT_REQUEST_ID;'))
,p_xml_structure=>'APEX'
,p_format=>'PDF'
,p_output_file_name=>'payment request '
,p_content_disposition=>'ATTACHMENT'
,p_xml_items=>'P2_PAYMENT_REQUEST_ID'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(3125242920677472)
,p_shared_query_id=>wwv_flow_api.id(3124507647621743)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_number,',
'    request_date,',
'    (select v.vendor_name ',
'        from vendors v',
'        where v.vendor_number = pra.vendor_number',
'        and v.vendor_site_code =  pra.vendor_site_code',
'        and rownum = 1) Vendor_name,',
'    invoice_number,',
'    invoice_description,',
'    currency_code,',
'    invoice_amount,',
'    iban,',
'    completion_date',
'FROM',
'    payment_requests_all pra',
'WHERE',
'    payment_request_id = :P2_PAYMENT_REQUEST_ID;'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(3125473487677472)
,p_shared_query_id=>wwv_flow_api.id(3124507647621743)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'       STEP_NO,',
'       ACTION_REQUIRED,',
'       e.USER_NAME,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       (select r.role_name',
'        from roles r',
'        where r.main_category = 23',
'        and r.role_id = cc.role_id) role_name,',
'       e.full_name_en',
'  from payment_request_APPROVAL_HISTORY cc,  dct_employees_list2  e',
'  where cc.person_id = e.person_id (+)',
'and  cc.payment_request_id = :P2_PAYMENT_REQUEST_ID',
'order by step_no , ID'))
);
wwv_flow_api.component_end;
end;
/
