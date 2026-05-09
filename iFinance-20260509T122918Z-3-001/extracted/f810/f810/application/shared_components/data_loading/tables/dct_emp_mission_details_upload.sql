prompt --application/shared_components/data_loading/tables/dct_emp_mission_details_upload
begin
--   Manifest
--     DCT_EMP_MISSION_DETAILS_UPLOAD
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_load_table(
 p_id=>wwv_flow_api.id(83988515203044306)
,p_name=>'outsource Emp Missions Details Upload'
,p_owner=>'#OWNER#'
,p_table_name=>'DCT_EMP_MISSION_DETAILS_UPLOAD'
,p_unique_column_1=>'EMPLOYEE_NUM'
,p_is_uk1_case_sensitive=>'N'
,p_is_uk2_case_sensitive=>'N'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.create_load_table_lookup(
 p_id=>wwv_flow_api.id(84200790665784219)
,p_load_table_id=>wwv_flow_api.id(83988515203044306)
,p_load_column_name=>'PAYROLL_AREA_ID'
,p_lookup_owner=>'#OWNER#'
,p_lookup_table_name=>'PAYROLL_AREAS'
,p_key_column=>'PAYROLL_AREA_ID'
,p_display_column=>'PAYROLL_AREA'
,p_insert_new_value=>'N'
);
wwv_flow_api.create_load_table_lookup(
 p_id=>wwv_flow_api.id(84199171146731073)
,p_load_table_id=>wwv_flow_api.id(83988515203044306)
,p_load_column_name=>'GRADE_ID_USER'
,p_lookup_owner=>'#OWNER#'
,p_lookup_table_name=>'DCT_EMPLOYEES_LOOKUPS'
,p_key_column=>'CODE'
,p_display_column=>'DESC_E'
,p_where_clause=>'LOOKUP_NUMBER = 3'
,p_insert_new_value=>'N'
);
wwv_flow_api.create_load_table_lookup(
 p_id=>wwv_flow_api.id(84200475197779091)
,p_load_table_id=>wwv_flow_api.id(83988515203044306)
,p_load_column_name=>'LOCATION_ID_USER'
,p_lookup_owner=>'#OWNER#'
,p_lookup_table_name=>'DCT_EMPLOYEES_LOOKUPS'
,p_key_column=>'CODE'
,p_display_column=>'DESC_E'
,p_where_clause=>'lookup_number = 15'
,p_insert_new_value=>'N'
);
wwv_flow_api.create_load_table_rule(
 p_id=>wwv_flow_api.id(83988813869044311)
,p_load_table_id=>wwv_flow_api.id(83988515203044306)
,p_load_column_name=>'EMAIL_ACCOUNT'
,p_rule_name=>'Email Account Rule'
,p_rule_type=>'SQL_QUERY_SINGLE_VALUE'
,p_rule_sequence=>10
,p_rule_expression1=>'select user_details.get_emp_Email_account(:email_user) from dual'
);
wwv_flow_api.create_load_table_rule(
 p_id=>wwv_flow_api.id(83989148716044316)
,p_load_table_id=>wwv_flow_api.id(83988515203044306)
,p_load_column_name=>'EMAIL_DOMAIN'
,p_rule_name=>'Email Domain Rule'
,p_rule_type=>'PLSQL_EXPRESSION'
,p_rule_sequence=>20
,p_rule_expression1=>'user_details.get_emp_Email_domain(:email_user)'
);
wwv_flow_api.component_end;
end;
/
