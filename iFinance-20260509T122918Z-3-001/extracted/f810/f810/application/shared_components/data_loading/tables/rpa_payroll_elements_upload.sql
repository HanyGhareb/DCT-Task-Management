prompt --application/shared_components/data_loading/tables/rpa_payroll_elements_upload
begin
--   Manifest
--     RPA_PAYROLL_ELEMENTS_UPLOAD
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
 p_id=>wwv_flow_api.id(47942214107917079)
,p_name=>'Upload Payroll Elements'
,p_owner=>'#OWNER#'
,p_table_name=>'RPA_PAYROLL_ELEMENTS_UPLOAD'
,p_unique_column_1=>'EMPLOYEE_NUMBER'
,p_is_uk1_case_sensitive=>'N'
,p_unique_column_2=>'ELEMENT_NAME'
,p_is_uk2_case_sensitive=>'N'
,p_unique_column_3=>'STATUS'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.component_end;
end;
/
