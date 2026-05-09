prompt --application/shared_components/user_interface/lovs/vendors_with_bank_accounts
begin
--   Manifest
--     VENDORS WITH BANK ACCOUNTS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(2910371296585288)
,p_lov_name=>'VENDORS WITH BANK ACCOUNTS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select v.VENDOR_NAME, ',
'       vba.VENDOR_SITE_CODE, ',
'       vba.VENDOR_NUMBER, ',
'       vba.BANK_ACCOUNT_NAME, ',
'       vba.BANK_NAME, ',
'       vba.BANK_ACCOUNT, ',
'       IBAN',
'from vendors  v, vendors_bank_accounts vba',
'where v.vendor_site_status = ''Active''',
'and v.vendor_number = vba.vendor_number',
'and v.vendor_site_code = vba.vendor_site_code',
'and vba.ACC_END_DATED is null; '))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'IBAN'
,p_display_column_name=>'IBAN'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'IBAN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(2910885753577456)
,p_query_column_name=>'VENDOR_NAME'
,p_heading=>'Vendor Name'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(2929330314456609)
,p_query_column_name=>'BANK_ACCOUNT_NAME'
,p_heading=>'Bank Account Name'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(2911245546577456)
,p_query_column_name=>'VENDOR_NUMBER'
,p_heading=>'Vendor Num'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(2911632990577455)
,p_query_column_name=>'VENDOR_SITE_CODE'
,p_heading=>'Vendor Site'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(2912088836577455)
,p_query_column_name=>'IBAN'
,p_heading=>'IBAN'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(2912471048577455)
,p_query_column_name=>'BANK_ACCOUNT'
,p_heading=>'Bank Account'
,p_display_sequence=>50
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(2912868176577455)
,p_query_column_name=>'BANK_NAME'
,p_heading=>'Bank Name'
,p_display_sequence=>60
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.component_end;
end;
/
