prompt --application/shared_components/reports/report_queries/issuing_gift_card_letter
begin
--   Manifest
--     WEB SERVICE: issuing gift card letter
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(116325808216231217)
,p_name=>'issuing gift card letter'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   gc.REQUEST_DATE ',
'       , gc.REFERENCE_NUMBER',
'       , gift_cards_workflow.get_bank_name(gc.GIFT_CARDS_SETTING_ID) Bank_name',
'       , gift_cards_workflow.get_subject_name(gc.GIFT_CARDS_SETTING_ID) subject',
'       , gift_cards_workflow.get_dct_bank_account(gc.GIFT_CARDS_SETTING_ID) bank_account_no',
'       , (',
'            select nvl(sum(l.CONTROL_COUNT),0) ',
'            from gift_cards_request_lines l',
'            where l.request_id = gc.id',
'            )           card_count',
'       , gift_cards_workflow.get_dct_printed_name(gc.GIFT_CARDS_SETTING_ID) bdct_printed_name',
'       ',
'from gift_cards_requests gc',
'where gc.id = :P26_ID;'))
,p_xml_structure=>'APEX'
,p_report_layout_id=>wwv_flow_api.id(116144624789425447)
,p_format=>'PDF'
,p_output_file_name=>'issuing gift card letter'
,p_content_disposition=>'INLINE'
,p_xml_items=>'P26_ID'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(114971718175433432)
,p_shared_query_id=>wwv_flow_api.id(116325808216231217)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   to_char(gc.REQUEST_DATE , ''DD-MON-YYYY'') REQUEST_DATE',
'       , gc.REFERENCE_NUMBER',
'       , gift_cards_workflow.get_bank_name(gc.GIFT_CARDS_SETTING_ID) Bank_name',
'       , gift_cards_workflow.get_subject_name(gc.GIFT_CARDS_SETTING_ID) subject',
'       , gift_cards_workflow.get_dct_bank_account(gc.GIFT_CARDS_SETTING_ID) bank_account_no',
'       , (',
'            select nvl(sum(l.CONTROL_COUNT),0) ',
'            from gift_cards_request_lines l',
'            where l.request_id = gc.id',
'            )           card_count',
'       , gift_cards_workflow.get_dct_printed_name(gc.GIFT_CARDS_SETTING_ID) bdct_printed_name',
'       , gift_cards_workflow.get_approver1(gc.GIFT_CARDS_SETTING_ID)  approver1',
'       , gift_cards_workflow.get_approver1_position(gc.GIFT_CARDS_SETTING_ID)  approver1_position',
'       , gift_cards_workflow.get_approver2(gc.GIFT_CARDS_SETTING_ID)  approver2',
'       , gift_cards_workflow.get_approver2_position(gc.GIFT_CARDS_SETTING_ID)  approver2_position',
'       ',
'from gift_cards_requests gc',
'where gc.id =  :P26_ID2    --:P26_PRINT;'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(114971523891433432)
,p_shared_query_id=>wwv_flow_api.id(116325808216231217)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ''AED '' || ',
'    trim(to_char(gift_cards_workflow.get_gift_card_value(l.gift_cards_category_id), ''99,999,999,999.99''))         limit,',
'    l.control_count || '' Cards''                                                          number_of_cards,',
'    trim(to_char(l.control_amount, ''99,999,999,999.99''))                                                          total_amount',
'FROM',
'    gift_cards_request_lines l',
'WHERE',
'    l.request_id = :P26_ID2 --:P26_PRINT;'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(114971338112433432)
,p_shared_query_id=>wwv_flow_api.id(116325808216231217)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select      trim(to_char(FEES,''99,999,999''))     FEES',
'        , amount',
'        ,trim(to_char(VAT,''99,999,999.99'')) VAT ',
'        , trim(to_char(FEES + VAT + amount,''99,999,999.99'')) total_cost',
'from',
'(select sum(CONTROL_AMOUNT) amount,',
'       Sum(gift_cards_workflow.get_gift_card_fee_value(GIFT_CARDS_CATEGORY_ID) * CONTROL_COUNT)	Fees,',
'       Sum((gift_cards_workflow.get_vat_pct(GIFT_CARDS_SETTING_ID)  * ',
'       (gift_cards_workflow.get_gift_card_fee_value(GIFT_CARDS_CATEGORY_ID) * CONTROL_COUNT)',
'       ))  VAT',
'  from GIFT_CARDS_REQUEST_LINES',
' where REQUEST_ID = :P26_ID2    --:P26_PRINT',
' ) '))
);
wwv_flow_api.component_end;
end;
/
