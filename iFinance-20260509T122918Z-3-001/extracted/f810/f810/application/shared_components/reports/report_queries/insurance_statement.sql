prompt --application/shared_components/reports/report_queries/insurance_statement
begin
--   Manifest
--     WEB SERVICE: insurance statement
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(13016846542282365)
,p_name=>'insurance statement'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    vendor_name,',
'    ''30-SEP-20'' AS_OF,',
'    invoice_num,',
'    description,',
'    invoice_date,',
'    invoice_amount,',
'    ',
'    CASE',
'        WHEN check_date <= ''30-SEP-20'' THEN',
'            invoice_payment_amount',
'        ELSE',
'            0',
'    END  paid_amount,',
'    CASE',
'        WHEN check_date <= ''30-SEP-20'' THEN',
'            check_date',
'        ELSE',
'            NULL',
'    END  payment_date',
'FROM',
'    (',
'        SELECT',
'            *',
'        FROM',
'            insurance_invoices',
'        WHERE',
'                invoice_date <= ''30-SEP-20''',
'           ',
'    )'))
,p_report_layout_id=>wwv_flow_api.id(13064270255605841)
,p_format=>'PDF'
,p_output_file_name=>'insurance statement'
,p_content_disposition=>'INLINE'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(13065203091614459)
,p_shared_query_id=>wwv_flow_api.id(13016846542282365)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select INVOICE_NUM, DESCRIPTION, INVOICE_DATE, INVOICE_AMOUNT, ',
'        PAID_AMOUNT, PAYMENT_DATE, DEPOSIT_AMOUNT, CLEAR_DATE',
'        , INVOICE_AMOUNT - DEPOSIT_AMOUNT  as Balance',
'from',
'(SELECT',
'    invoice_num,',
'    description,',
'    invoice_date,',
'    invoice_amount,',
'    CASE',
'        WHEN check_date <= :p2_as_of THEN',
'            invoice_payment_amount',
'        ELSE',
'            0',
'    END  paid_amount,',
'    CASE',
'        WHEN check_date <= :p2_as_of THEN',
'            check_date',
'        ELSE',
'            NULL',
'    END  payment_date,',
'      CASE',
'        WHEN CLEAR_DATE <= :p2_as_of THEN',
'            invoice_payment_amount',
'        ELSE',
'            0',
'    END  deposit_amount,',
'    CLEAR_DATE',
'FROM',
'    (',
'        SELECT',
'            *',
'        FROM',
'            insurance_invoices',
'        WHERE',
'                invoice_date <= :p2_as_of',
'            AND vendor_name = :p2_vendor_name',
'    ))',
'    order by INVOICE_DATE'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(13065490910614459)
,p_shared_query_id=>wwv_flow_api.id(13016846542282365)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select :P2_as_of AS_OF , :P2_vendor_name VENDOR_NAME',
'from dual'))
);
wwv_flow_api.component_end;
end;
/
