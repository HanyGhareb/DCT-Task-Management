prompt --application/shared_components/reports/report_queries/credit_card_request
begin
--   Manifest
--     WEB SERVICE: Credit Card Request
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(35036464082310789)
,p_name=>'Credit Card Request'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select --cc.*,',
'        cc.full_name',
'        , cc.birth_date',
'        , cc.sex',
'        , cc.passport_no',
'        , cc.passport_expire_date',
'        , cc.uae_residence_no',
'        , cc.uae_residence_expire_date',
'        , cc.emirates_id',
'        , cc.emirates_id_expire_date',
'        , cc.mother_name',
'        , (select nvl(DESC_E_USER, DESC_E) name ',
'from dct_employees_lookups',
'where lookup_number = 1',
'and code = cc.nationality_id) nationality',
'        , cc.office_number',
'        , cc.mobile_number',
'        , cc.email',
'        , cc.position_name',
'        , cc.employee_number',
'        , cc.requestor_person_id',
'from credit_cards cc',
'where cc.requestor_person_id = 127647;'))
,p_xml_structure=>'APEX'
,p_format=>'PDF'
,p_output_file_name=>'Credit Card Request'
,p_content_disposition=>'ATTACHMENT'
,p_xml_items=>'P2_REQUESTOR_PERSON_ID'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(38466094101626307)
,p_shared_query_id=>wwv_flow_api.id(35036464082310789)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select --cc.*,',
'        cc.full_name',
'        , cc.birth_date',
'        , cc.sex',
'        , cc.passport_no',
'        , cc.passport_expire_date',
'        , cc.uae_residence_no',
'        , cc.uae_residence_expire_date',
'        , cc.emirates_id',
'        , cc.emirates_id_expire_date',
'        , cc.mother_name',
'        , (select nvl(DESC_E_USER, DESC_E) name ',
'from dct_employees_lookups',
'where lookup_number = 1',
'and code = cc.nationality_id) nationality',
'        , cc.office_number',
'        , cc.mobile_number',
'        , cc.email',
'        , cc.position_name',
'        , cc.employee_number',
'        , cc.requestor_person_id',
'from credit_cards cc',
'where cc.requestor_person_id = 127647;'))
);
wwv_flow_api.component_end;
end;
/
