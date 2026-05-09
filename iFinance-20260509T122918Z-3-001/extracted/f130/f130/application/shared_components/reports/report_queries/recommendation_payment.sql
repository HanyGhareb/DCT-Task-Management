prompt --application/shared_components/reports/report_queries/recommendation_payment
begin
--   Manifest
--     WEB SERVICE: Recommendation Payment
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(32659570474492045)
,p_name=>'Recommendation Payment'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
'      ,trim(to_char(nvl(c.initial_contract_amount,0),''99,999,999.99''))      Original_agreement_fee',
'      ,c.contract_reference             Agreement_REF',
'      ,trim(to_char(nvl(c.contract_variation_amount,0),''99,999,999.99''))      Approved_Variation',
'      ,cpr.contract_number                                                               Purchase_order              -- XXX',
'      ,trim(to_char(nvl(c.contract_amount ,0),''99,999,999.99''))               Revised_agreement_fee',
'      ',
'    -- 2nd Part  ',
'      ,cpr.invoice_num                                                  invoice_num',
'      ,to_char(cpr.invoice_date,''DD-MON-YYYY'')                          invoice_date',
'      ,trim(to_char(nvl(cpr.total_invoice_amount,0),''99,999,999.99''))         total_invoice_amount',
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
'        ),''99,999,999.99''))                                            Cumulative_Certified_to_date  -- XXXX',
'      ,cpr.VALUATION_PERIOD_FROM                                        Certified_Date                -- XXX',
'      ,trim(to_char((',
'    select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = cpr.contract_number',
'--    and a.approval_status = ''Approved''',
'    and a.seq_count < cpr.seq_count',
'    ),''99,999,999.99''))            Previously_certified',
'      ,cpr.currency                                                             Currency',
'      ,trim(to_char(nvl(cpr.current_valuation_amount,0),''99,999,999.99''))     Due_amount_without_VAT',
'      ',
'     --4th Part',
'     ,dct_util.spell_number(cpr.net_amount_payable) || '' Only Including VAT''   Due_amount_With_VAT_words',
'     ',
'      ,trim(to_char(nvl(cpr.current_valuation_amount,0),''99,999,999.99''))     current_valuation_amount',
'      ,cpr.period',
'      ,trim(to_char(nvl(cpr.deductions,0),''99,999,999.99''))                   deductions',
'    -- 5th Part',
'      ,cpr.scope_of_work',
'      ,cpr.remark',
'',
'      ,cpr.approval_status',
'from cwip_payment_recommendation cpr, cwip_contract c',
'where cpr.payment_recommendation_id = :P4_PAYMENT_RECOMMENDATION_ID_H -- 78',
'and cpr.contract_number = c.contract_number;'))
,p_xml_structure=>'APEX'
,p_report_layout_id=>wwv_flow_api.id(40144580656217993)
,p_format=>'PDF'
,p_output_file_name=>'Recommendation Payment'
,p_content_disposition=>'INLINE'
,p_xml_items=>'P29_PR_ID'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(99625544233250924)
,p_shared_query_id=>wwv_flow_api.id(32659570474492045)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  cpr.reference_number',
'        ,to_char(cpr.created_on,''DD-MON-YYYY'')            Date_Prepared',
'        ,(select nvl(p.dct_project_name,p.project_name)',
'          from project p',
'          where p.project_number = (select cp.project_number',
'                                    from cwip_contract_projects cp',
'                                    where cp.contract_number = cpr.contract_number',
'                                    and rownum = 1)) Project_name',
'       ,to_char(cpr.final_approve_on,''DD-MON-YYYY'')        Effective_date',
'       ,nvl(c.VENDOR_NAME , (select v.vendor_name',
'        from vendors v',
'        where v.vendor_number = c.vendor_number',
'        and v.vendor_site_code = c.vendor_site_code)) Contracting_Party',
'      ,to_char(cpr.VALUATION_PERIOD_FROM ,''DD-MON-YYYY'')                       Agreement_period',
'      ,c.contract_title',
'      ,trim(to_char(nvl(c.initial_contract_amount,0),''99,999,999,999.99''))      Original_agreement_fee',
'      ,c.contract_reference             Agreement_REF',
'      ,trim(to_char(nvl(nvl(c.dct_contract_variation_amount, c.contract_variation_amount),0),''99,999,999,999.99''))      Approved_Variation',
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
'      ,to_char(cpr.VALUATION_PERIOD_FROM,''DD-MON-YYYY'')                             Certified_Date                -- XXX',
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
' --    ,dct_util.spell_number(cpr.net_amount_payable) || '' Only Including VAT''   Due_amount_With_VAT_words',
'     ,dct_util.spell_number(cpr.total_invoice_amount) || '' Only Including VAT''   Due_amount_With_VAT_words',
'      ,trim(to_char(nvl(cpr.current_valuation_amount,0),''99,999,999,999.99''))     current_valuation_amount',
'      ,cpr.period',
'      ,trim(to_char(nvl(cpr.deductions,0),''99,999,999,999.99''))                   deductions',
'    -- 5th Part',
'      ,cpr.scope_of_work',
'      ,cpr.remark',
'',
'      ,cpr.approval_status',
'from cwip_payment_recommendation cpr, cwip_contract c',
'where cpr.payment_recommendation_id = :P29_PR_ID',
'and cpr.contract_number = c.contract_number;'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(99625690266250924)
,p_shared_query_id=>wwv_flow_api.id(32659570474492045)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(nvl(FILE_COMMENTS ,FILENAME )) document_name',
'from cwip_payment_recommendation_documents',
'where payment_recommendation_id = :P29_PR_ID'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(99625868706250924)
,p_shared_query_id=>wwv_flow_api.id(32659570474492045)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
' --   payment_recommendation_id,',
'    step_no,',
'  --  person_id,',
'    full_name,',
'  --  person_type,',
'    role_id,',
'    case on_behalf when ''Y'' then ''on-behalf '' || role_name',
'                        else role_name',
'    end role_name,',
'    action_required,',
'    recevied_date,',
'    status,',
'    action_date,',
'    comments,',
'    Signature',
'from (select ID,',
'       PAYMENT_RECOMMENDATION_ID,',
'       STEP_NO,',
'       PERSON_ID,',
'       (case person_type when ''INT''  Then',
'                                (select initcap(e.full_name_en) from employees_v e where e.person_id = h.person_id)',
'                         when ''EXT''  Then',
'                                (select initcap(u.first_name || '' '' || u.last_name) from dct_ext_users u where u.user_id = h.person_id)',
'           End                      ) Full_name,',
'           ',
'       (case person_type when ''INT''  Then',
'                                (select e.user_name from employees_v e where e.person_id = h.person_id)',
'                         when ''EXT''  Then',
'                                (select u.user_name from dct_ext_users u where u.user_id = h.person_id)',
'           End                      ) User_name,    ',
'       PERSON_TYPE,',
'       ROLE_ID,',
'       (select r.role_name from project_role r where r.role_id = h.role_id) Role_Name,',
'       ACTION_REQUIRED,',
'       to_char(RECEVIED_DATE,''DD-Mon-YYYY'') RECEVIED_DATE,',
'       STATUS,',
'       to_char(ACTION_DATE,''DD-Mon-YYYY'') ACTION_DATE,',
'       COMMENTS',
'',
'      , h.on_behalf   ',
'      ,case when dbms_lob.getlength((select s.SIGNATURE_BLOB',
'                               from dct_employees_signatures s',
'                                where s.person_id = h.person_id',
'                                and s.status = ''Y''))  > 0 THEN',
'            (select s.signature_clob',
'    from dct_employees_signatures s',
'    where s.person_id = h.person_id',
'    and s.status = ''Y'') End as Signature',
'  from CWIP_PAYMENT_REC_APPROVAL_HISTORY h',
'  where PAYMENT_RECOMMENDATION_ID = :P29_PR_ID',
'  and STATUS not in (''Bateen'')',
'      )',
'  order by step_no , id '))
);
wwv_flow_api.component_end;
end;
/
