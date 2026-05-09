prompt --application/shared_components/data_loading/tables/project_balances_upload
begin
--   Manifest
--     PROJECT_BALANCES_UPLOAD
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
 p_id=>wwv_flow_api.id(91082901976836690)
,p_name=>'Projects Balances Upload'
,p_owner=>'#OWNER#'
,p_table_name=>'PROJECT_BALANCES_UPLOAD'
,p_unique_column_1=>'PROJECT_NUMBER'
,p_is_uk1_case_sensitive=>'N'
,p_unique_column_2=>'TASK_NUMBER'
,p_is_uk2_case_sensitive=>'Y'
,p_unique_column_3=>'EXP_TYPE'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.component_end;
end;
/
