prompt --application/shared_components/user_interface/lovs/external_users_full_details_lov
begin
--   Manifest
--     EXTERNAL USERS FULL DETAILS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(20706258549434059)
,p_lov_name=>'EXTERNAL USERS FULL DETAILS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select first_name || '' '' || last_name  full_name , user_id ',
'        , email',
'        , (select v.vendor_name',
'            from vendors v',
'            where v.vendor_number = dct_ext_users.vendor_number',
'            and v.vendor_site_code = dct_ext_users.vendor_site_code',
'            and v.vendor_site_status = ''Active''',
'            and v.enabled_flag = ''Y''',
'           and rownum = 1) Vendor',
'from dct_ext_users',
'where 1=1',
'-- and account_status = ''A''',
'order by email;;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'USER_ID'
,p_display_column_name=>'FULL_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'EMAIL'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20706679757435795)
,p_query_column_name=>'USER_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20707093604435795)
,p_query_column_name=>'FULL_NAME'
,p_heading=>'Full Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20707419153435796)
,p_query_column_name=>'EMAIL'
,p_heading=>'Email'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20707804218435796)
,p_query_column_name=>'VENDOR'
,p_heading=>'Vendor'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
