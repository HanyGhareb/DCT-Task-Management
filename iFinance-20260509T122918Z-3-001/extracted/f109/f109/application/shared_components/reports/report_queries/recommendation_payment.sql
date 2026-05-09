prompt --application/shared_components/reports/report_queries/recommendation_payment
begin
--   Manifest
--     WEB SERVICE: Recommendation Payment
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(21771268931022461)
,p_name=>'Recommendation Payment'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select cpr.reference_number',
'        ,to_char(cpr.created_on,''DD-MON-YYYY'')            Date_Prepared',
'        ,(select nvl(p.dct_project_name,p.project_name)',
'          from project p',
'          where p.project_number = (select cp.project_number',
'                                    from cwip_contract_projects cp',
'                                    where cp.contract_number = cpr.contract_number)) Project_name',
'       ,to_char(cpr.final_approve_on,''DD-MON-YYYY'')        Effective_date',
'       ,(select v.vendor_name',
'        from vendors v',
'        where v.vendor_number = c.vendor_number',
'        and v.vendor_site_code = c.vendor_site_code) Contracting_Party',
'      ,cpr.period                       Agreement_period',
'      ,c.contract_title',
'      ,to_char(nvl(c.initial_contract_amount,0),''99,999,999.99'')      Original_agreement_fee',
'      ,c.contract_reference             Agreement_REF',
'      ,to_char(nvl(c.contract_variation_amount,0),''99,999,999.99'')      Approved_Variation',
'      ,to_char(nvl(c.contract_amount ,0),''99,999,999.99'')               Revised_agreement_fee',
'      ,(select l.value ',
'        from cwip_lookup_values l',
'        where lookup_id = 2',
'        and l.value_id = cpr.payment_type)                               Payment_type',
'      ,cpr.invoice_num',
'      ,to_char(cpr.invoice_date,''DD-MON-YYYY'')                          invoice_date',
'      ,to_char(nvl(cpr.total_invoice_amount,0),''99,999,999.99'')         total_invoice_amount',
'      ,to_char(nvl(cpr.current_valuation_amount,0),''99,999,999.99'')     current_valuation_amount',
'      ,cpr.period',
'      ,to_char(nvl(cpr.deductions,0),''99,999,999.99'')                   deductions',
'      ,to_char(nvl(cpr.previous_payments,0),''99,999,999.99'')            previous_payments',
'      ,to_char(nvl(cpr.net_amount_payable,0),''99,999,999.99'')           net_amount_payable',
'      ,cpr.approval_status',
'from cwip_payment_recommendation cpr, cwip_contract c',
'where cpr.payment_recommendation_id = :P4_PAYMENT_RECOMMENDATION_ID_H --4',
'and cpr.contract_number = c.contract_number;'))
,p_report_layout_id=>wwv_flow_api.id(32658317536508450)
,p_format=>'PDF'
,p_output_file_name=>'Recommendation Payment'
,p_content_disposition=>'INLINE'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(39463674911494797)
,p_shared_query_id=>wwv_flow_api.id(21771268931022461)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  cpr.reference_number',
'        ,to_char(cpr.created_on,''DD-MON-YYYY'')            Date_Prepared',
'        ,(select nvl(p.dct_project_name,p.project_name)',
'          from project p',
'          where p.project_number = (select cp.project_number',
'                                    from cwip_contract_projects cp',
'                                    where cp.contract_number = cpr.contract_number)) Project_name',
'       ,to_char(cpr.final_approve_on,''DD-MON-YYYY'')        Effective_date',
'       ,(select v.vendor_name',
'        from vendors v',
'        where v.vendor_number = c.vendor_number',
'        and v.vendor_site_code = c.vendor_site_code) Contracting_Party',
'      ,cpr.period                       Agreement_period',
'      ,c.contract_title',
'      ,trim(to_char(nvl(c.initial_contract_amount,0),''99,999,999,999.99''))      Original_agreement_fee',
'      ,c.contract_reference             Agreement_REF',
'      ,trim(to_char(nvl(c.contract_variation_amount,0),''99,999,999,999.99''))      Approved_Variation',
'      ,cpr.contract_number                                                               Purchase_order              -- XXX',
'      ,trim(to_char(nvl(c.contract_amount ,0),''99,999,999,999.99''))               Revised_agreement_fee',
'      ',
'    -- 2nd Part  ',
'      ,cpr.invoice_num                                                  invoice_num',
'      ,to_char(cpr.invoice_date,''DD-MON-YYYY'')                          invoice_date',
'      ,trim(to_char(nvl(cpr.total_invoice_amount,0),''99,999,999,999.99''))         total_invoice_amount',
'      ',
'    --3rd Part  ',
'      ,(select l.value ',
'        from cwip_lookup_values l',
'        where lookup_id = 2',
'        and l.value_id = cpr.payment_type)                               Payment_type',
'      ,trim(to_char((',
'        (select nvl(sum(a.net_amount_payable),0)',
'        from cwip_payment_recommendation a',
'        where a.contract_number = cpr.contract_number',
'        and a.seq_count < cpr.seq_count ',
'        ) + cpr.net_amount_payable',
'        ),''99,999,999,999.99''))                                            Cumulative_Certified_to_date  -- XXXX',
'      ,cpr.VALUATION_PERIOD_FROM                                        Certified_Date                -- XXX',
'      ,trim(to_char((',
'    select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = cpr.contract_number',
'--    and a.approval_status = ''Approved''',
'    and a.seq_count < cpr.seq_count',
'    ),''99,999,999,999.99''))            Previously_certified',
'      ,cpr.currency                                                             Currency',
'      ,trim(to_char(nvl(cpr.current_valuation_amount,0),''99,999,999,999.99''))     Due_amount_without_VAT',
'      ',
'     --4th Part',
'     ,dct_util.spell_number(cpr.net_amount_payable) || '' Only Including VAT''   Due_amount_With_VAT_words',
'     ',
'      ,trim(to_char(nvl(cpr.current_valuation_amount,0),''99,999,999,999.99''))     current_valuation_amount',
'      ,cpr.period',
'      ,trim(to_char(nvl(cpr.deductions,0),''99,999,999,999.99''))                   deductions',
'    -- 5th Part',
'      ,cpr.scope_of_work',
'      ,cpr.remark',
'',
'      ,cpr.approval_status',
'from cwip_payment_recommendation cpr, cwip_contract c',
'where cpr.payment_recommendation_id = :P4_PAYMENT_RECOMMENDATION_ID_H -- 78',
'and cpr.contract_number = c.contract_number;'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(39463401790494797)
,p_shared_query_id=>wwv_flow_api.id(21771268931022461)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(nvl(FILE_COMMENTS ,FILENAME )) document_name',
'from cwip_payment_recommendation_documents',
'where payment_recommendation_id = :P4_PAYMENT_RECOMMENDATION_ID_H --63'))
);
wwv_flow_api.component_end;
end;
/
