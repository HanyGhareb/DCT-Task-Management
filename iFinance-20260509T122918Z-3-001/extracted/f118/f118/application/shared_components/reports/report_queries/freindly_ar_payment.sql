prompt --application/shared_components/reports/report_queries/freindly_ar_payment
begin
--   Manifest
--     WEB SERVICE: Freindly_AR_Payment
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(124321720529088038)
,p_name=>'Freindly_AR_Payment'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select to_char(DUE_DATE,''DD-MON-YYYY'') DUE_DATE ',
'     , AMOUNT_DUE_REMAINING',
'     , TRANSACTION_NUMBER',
'     , TYPE_DESCRIPTION',
'     , ESCALATE',
'from(',
'select CUSTOMER_NUMBER,',
'       CUSTOMER_NAME,',
'       AMOUNT_DUE_REMAINING,',
'       TRANSACTION_NUMBER,',
'       TYPE_DESCRIPTION,',
'       DUE_DATE,',
'       CREATION_DATE,',
'       round(sysdate - due_date) + 1 Days,',
'       case when round(sysdate - due_date) + 1 > 180        Then ''Final''',
'            when 180 >= round(sysdate - due_date) + ',
'            1 and round(sysdate - due_date) + 1> 60        Then ''Official''',
'            when 60 >= round(sysdate - due_date) + ',
'            1 and round(sysdate - due_date) + 1> 30        Then ''Friendly''',
'            else ''NA''',
'       End Escalate,  ',
'       TRUST_YN',
'  from AR_DUE_TRANSACTIONS',
'  )',
' WHERE  CUSTOMER_NUMBER = :P_CUSTOMER_NUMBER',
' and ESCALATE = ''Friendly'';'))
,p_format=>'PDF'
,p_output_file_name=>'Freindly_AR_Payment'
,p_content_disposition=>'ATTACHMENT'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(124535059810709579)
,p_shared_query_id=>wwv_flow_api.id(124321720529088038)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select to_char(DUE_DATE,''DD-MON-YYYY'') DUE_DATE ',
'     , AMOUNT_DUE_REMAINING',
'     , TRANSACTION_NUMBER',
'     , TYPE_DESCRIPTION',
'     , ESCALATE',
'from(',
'select CUSTOMER_NUMBER,',
'       CUSTOMER_NAME,',
'       AMOUNT_DUE_REMAINING,',
'       TRANSACTION_NUMBER,',
'       TYPE_DESCRIPTION,',
'       DUE_DATE,',
'       CREATION_DATE,',
'       round(sysdate - due_date) + 1 Days,',
'       case when round(sysdate - due_date) + 1 > 180        Then ''Final''',
'            when 180 >= round(sysdate - due_date) + ',
'            1 and round(sysdate - due_date) + 1> 60        Then ''Official''',
'            when 60 >= round(sysdate - due_date) + ',
'            1 and round(sysdate - due_date) + 1> 30        Then ''Friendly''',
'            else ''NA''',
'       End Escalate,  ',
'       TRUST_YN',
'  from AR_DUE_TRANSACTIONS',
'  )',
' WHERE  CUSTOMER_NUMBER = :P_CUSTOMER_NUMBER',
' and ESCALATE = ''Friendly''',
' order by DUE_DATE, TRANSACTION_NUMBER;'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(124535279023709579)
,p_shared_query_id=>wwv_flow_api.id(124321720529088038)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select NVL(REPRESENTATIVE_NAME , CUSTOMER_NAME) CUSTOMER_NAME, ',
'       NVL(EMAIL_ADDRESS_USER , EMAIL_ADDRESS)  CUSTOMER_EMAIL ',
'from customers',
'where customer_number = :P_CUSTOMER_NUMBER',
'--and EMAIL_VERIFIED_YN = ''Y''',
';'))
);
wwv_flow_api.component_end;
end;
/
