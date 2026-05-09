prompt --application/shared_components/data_loading/tables/scm_pending_pr
begin
--   Manifest
--     SCM_PENDING_PR
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_load_table(
 p_id=>wwv_flow_api.id(4575474537965458)
,p_name=>'Pending PRs Upload'
,p_owner=>'#OWNER#'
,p_table_name=>'SCM_PENDING_PR'
,p_unique_column_1=>'PR_NUMBER'
,p_is_uk1_case_sensitive=>'Y'
,p_unique_column_2=>'REQUESTER'
,p_is_uk2_case_sensitive=>'N'
,p_unique_column_3=>'AMOUNT'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.create_load_table_lookup(
 p_id=>wwv_flow_api.id(4575204062965458)
,p_load_table_id=>wwv_flow_api.id(4575474537965458)
,p_load_column_name=>'EMAIL'
,p_lookup_owner=>'#OWNER#'
,p_lookup_table_name=>'EMPLOYEES_V'
,p_key_column=>'EMAIL'
,p_display_column=>'FULL_NAME_EN'
,p_insert_new_value=>'N'
);
wwv_flow_api.component_end;
end;
/
