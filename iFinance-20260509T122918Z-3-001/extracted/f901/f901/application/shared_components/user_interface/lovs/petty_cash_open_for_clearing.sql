prompt --application/shared_components/user_interface/lovs/petty_cash_open_for_clearing
begin
--   Manifest
--     PETTY CASH  OPEN FOR CLEARING
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>123
,p_default_id_offset=>6039605030667831
,p_default_owner=>'DEV'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(46380561467447021)
,p_lov_name=>'PETTY CASH  OPEN FOR CLEARING'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select petty_cash_id , petty_cash_no  ,to_char(amount,''99,999,999.99'') amount,',
'        Case petty_cash_type ',
'                when ''T'' then ''Temporary''',
'                when ''P''  then ''Permanent''',
'        end     Type        ',
'from hrss_petty_cash',
'where employee_num = :EMP_NUM',
'and paid_yn = ''Y''',
'order by 4',
'    '))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PETTY_CASH_ID'
,p_display_column_name=>'PETTY_CASH_NO'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'PETTY_CASH_NO'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(46381414834450370)
,p_query_column_name=>'PETTY_CASH_NO'
,p_heading=>'Petty Cash'
,p_display_sequence=>5
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(46381077980450369)
,p_query_column_name=>'PETTY_CASH_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(46381847193450370)
,p_query_column_name=>'AMOUNT'
,p_heading=>'Amount'
,p_display_sequence=>15
,p_data_type=>'NUMBER'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(46390495200503631)
,p_query_column_name=>'TYPE'
,p_heading=>'Type'
,p_display_sequence=>25
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
