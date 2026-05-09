prompt --application/shared_components/user_interface/lovs/bank_accounts_vendor
begin
--   Manifest
--     BANK ACCOUNTS - VENDOR
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(1189911462821778)
,p_lov_name=>'BANK ACCOUNTS - VENDOR'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   IBAN  , BANK_ACCOUNT, BANK_NAME, BANK_ACCOUNT_NAME',
'from vendors_bank_accounts',
'where VENDOR_NUMBER =  :P2_VENDOR_NUMBER',
'and VENDOR_SITE_CODE = :P2_VENDOR_SITE_CODE',
'and ACC_END_DATED is null'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'IBAN'
,p_display_column_name=>'IBAN'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'IBAN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(1190458492825612)
,p_query_column_name=>'IBAN'
,p_heading=>'IBAN'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(1190805844825612)
,p_query_column_name=>'BANK_ACCOUNT'
,p_heading=>'Bank Account'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(1191232308825612)
,p_query_column_name=>'BANK_NAME'
,p_heading=>'Bank Name'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(1191685326825613)
,p_query_column_name=>'BANK_ACCOUNT_NAME'
,p_heading=>'Bank Account Name'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
