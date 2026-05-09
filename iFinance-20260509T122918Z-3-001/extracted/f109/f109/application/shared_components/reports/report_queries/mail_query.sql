prompt --application/shared_components/reports/report_queries/mail_query
begin
--   Manifest
--     WEB SERVICE: Mail Query
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
 p_id=>wwv_flow_api.id(39171080633609889)
,p_name=>'Mail Query'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    pr.project_name                                    project,',
'    pr.contract_description                            contract_description,',
'    pr.vendor_name                                     Contracting_Party,',
'    pr.initial_contract_amount                         initial_contract_amount,',
'    pr.contract_amount - pr.initial_contract_amount       Approved_Variations,',
'    pr.contract_amount                                 Revised_Contract_Amount,',
'    pr.payment_type                                    payment_type,',
'    pr.evaluation_method                               Payment_method,',
'    pr.payment_number                                  payment_number,',
'    pr.contract_reference                                 contract_reference,',
'    pr.contract_number                                    Purchase_order,',
'    cont.contract_days                                 Agreement_Duration,',
'    cont.end_date                                      Completion_Date,',
'    pr.valuation_period_from                           Cumulative_Certified_to_Date,',
'    pr.cumulative_cerified_amount                      Previously_Certified,',
'    pr.net_amount_payable                              Net_Payable_Amount_excluding_VAT,',
'    pr.scope_of_work                                   scope_of_work,',
'    pr.remark                                          remark   ',
'FROM',
'    cwip_payment_recommendation_v  pr, cwip_contracts_v cont',
'where pr.contract_number = cont.contract_number',
'and pr.payment_recommendation_id = :ID'))
,p_format=>'PDF'
,p_output_file_name=>'Mail Query'
,p_content_disposition=>'ATTACHMENT'
);
wwv_flow_api.component_end;
end;
/
