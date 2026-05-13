prompt --application/shared_components/data_loading/tables/hrss_petty_cash_reminders
begin
--   Manifest
--     HRSS_PETTY_CASH_REMINDERS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_load_table(
 p_id=>wwv_flow_api.id(145420207978656450)
,p_name=>'Reminder Data'
,p_owner=>'#OWNER#'
,p_table_name=>'HRSS_PETTY_CASH_REMINDERS'
,p_unique_column_1=>'EMPLOYEE_NUM'
,p_is_uk1_case_sensitive=>'N'
,p_is_uk2_case_sensitive=>'N'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.create_load_table_rule(
 p_id=>wwv_flow_api.id(145420512518656450)
,p_load_table_id=>wwv_flow_api.id(145420207978656450)
,p_load_column_name=>'EMAIL'
,p_rule_name=>'Email'
,p_rule_type=>'PLSQL_EXPRESSION'
,p_rule_sequence=>10
,p_rule_expression1=>'user_details.get_emp_Email(user_details.get_personId_by_empNumber(:EMPLOYEE_NUM)) '
,p_rule_expression2=>':EMPLOYEE_NUM'
);
wwv_flow_api.create_load_table_rule(
 p_id=>wwv_flow_api.id(145420999973656451)
,p_load_table_id=>wwv_flow_api.id(145420207978656450)
,p_load_column_name=>'EMP_NAME'
,p_rule_name=>'Emp Name'
,p_rule_type=>'PLSQL_EXPRESSION'
,p_rule_sequence=>20
,p_rule_expression1=>'user_details.get_full_name(user_details.get_personId_by_empNumber(:EMPLOYEE_NUM))'
,p_rule_expression2=>':EMPLOYEE_NUM'
);
wwv_flow_api.component_end;
end;
/
