prompt --application/shared_components/data_loading/tables/customers
begin
--   Manifest
--     CUSTOMERS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_load_table(
 p_id=>wwv_flow_api.id(123793627157201910)
,p_name=>'Update Customers Emails'
,p_owner=>'#OWNER#'
,p_table_name=>'CUSTOMERS'
,p_unique_column_1=>'CUSTOMER_NUMBER'
,p_is_uk1_case_sensitive=>'N'
,p_is_uk2_case_sensitive=>'N'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.create_load_table_rule(
 p_id=>wwv_flow_api.id(123906064294169153)
,p_load_table_id=>wwv_flow_api.id(123793627157201910)
,p_load_column_name=>'EMAIL_VERIFIED_YN'
,p_rule_name=>'Set Verification '
,p_rule_type=>'PLSQL_FUNCTION_BODY'
,p_rule_sequence=>10
,p_rule_expression1=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'return ''Y'';',
'end;'))
);
wwv_flow_api.component_end;
end;
/
