prompt --application/shared_components/data_loading/tables/vendors_bank_accounts
begin
--   Manifest
--     VENDORS_BANK_ACCOUNTS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_load_table(
 p_id=>wwv_flow_api.id(100243225002075416)
,p_name=>'Vendor Bank Accounts Upload'
,p_owner=>'#OWNER#'
,p_table_name=>'VENDORS_BANK_ACCOUNTS'
,p_unique_column_1=>'VENDOR_NUMBER'
,p_is_uk1_case_sensitive=>'N'
,p_unique_column_2=>'VENDOR_SITE_CODE'
,p_is_uk2_case_sensitive=>'N'
,p_unique_column_3=>'BANK_ACCOUNT'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.component_end;
end;
/
