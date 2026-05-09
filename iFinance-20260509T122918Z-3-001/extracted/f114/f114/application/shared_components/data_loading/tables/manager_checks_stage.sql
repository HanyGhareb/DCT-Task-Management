prompt --application/shared_components/data_loading/tables/manager_checks_stage
begin
--   Manifest
--     MANAGER_CHECKS_STAGE
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_load_table(
 p_id=>wwv_flow_api.id(53903877260354319)
,p_name=>'Upload Managers Checks'
,p_owner=>'#OWNER#'
,p_table_name=>'MANAGER_CHECKS_STAGE'
,p_unique_column_1=>'PAYMENT_NO'
,p_is_uk1_case_sensitive=>'N'
,p_is_uk2_case_sensitive=>'N'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.create_load_table_rule(
 p_id=>wwv_flow_api.id(54017245795497952)
,p_load_table_id=>wwv_flow_api.id(53903877260354319)
,p_load_column_name=>'END_USER_EMAIL'
,p_rule_name=>'Mail Rule'
,p_rule_type=>'SQL_QUERY_SINGLE_VALUE'
,p_rule_sequence=>10
,p_rule_expression1=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select Substr(:END_USER_EMAIL, ',
'    Instr(:END_USER_EMAIL, ''<'')+1 ,',
'    ',
'    (Instr(:END_USER_EMAIL, ''>'') -',
'    Instr(:END_USER_EMAIL, ''<''))-1 ',
'    )',
'from dual'))
,p_rule_expression2=>':END_USER_EMAIL:END_USER_EMAIL:END_USER_EMAIL:END_USER_EMAIL'
);
wwv_flow_api.component_end;
end;
/
