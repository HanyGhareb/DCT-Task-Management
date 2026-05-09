prompt --application/shared_components/data_loading/tables/ba_projects_allocation
begin
--   Manifest
--     BA_PROJECTS_ALLOCATION
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_load_table(
 p_id=>wwv_flow_api.id(10393771590778265)
,p_name=>'Budget Allocation2024 -Quick'
,p_owner=>'#OWNER#'
,p_table_name=>'BA_PROJECTS_ALLOCATION'
,p_unique_column_1=>'ID'
,p_is_uk1_case_sensitive=>'N'
,p_is_uk2_case_sensitive=>'N'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.create_load_table_rule(
 p_id=>wwv_flow_api.id(10394155225778268)
,p_load_table_id=>wwv_flow_api.id(10393771590778265)
,p_load_column_name=>'FISICAL_YEAR'
,p_rule_name=>'Current Year'
,p_rule_type=>'SQL_QUERY_SINGLE_VALUE'
,p_rule_sequence=>10
,p_rule_expression1=>'select extract(year from sysdate) from dual'
);
wwv_flow_api.component_end;
end;
/
