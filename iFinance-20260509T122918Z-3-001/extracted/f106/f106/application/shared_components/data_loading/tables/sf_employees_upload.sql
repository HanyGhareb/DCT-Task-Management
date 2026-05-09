prompt --application/shared_components/data_loading/tables/sf_employees_upload
begin
--   Manifest
--     SF_EMPLOYEES_UPLOAD
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_load_table(
 p_id=>wwv_flow_api.id(3200336121379302)
,p_name=>'SAP SF Upload Data'
,p_owner=>'#OWNER#'
,p_table_name=>'SF_EMPLOYEES_UPLOAD'
,p_unique_column_1=>'SF_ID'
,p_is_uk1_case_sensitive=>'N'
,p_is_uk2_case_sensitive=>'N'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.component_end;
end;
/
