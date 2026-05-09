prompt --application/shared_components/user_interface/lovs/petty_cash_purpose_new
begin
--   Manifest
--     PETTY CASH PURPOSE-NEW
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
 p_id=>wwv_flow_api.id(8344978246994791)
,p_lov_name=>'PETTY CASH PURPOSE-NEW'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id ',
'from dct_lookup_values',
'where lookup_id = (select dct_lookups.lookup_id',
'                    from dct_lookups',
'                    where dct_lookups.lookup_code = ''HRSS-PC'')',
'and dct_lookup_values.status = ''A'''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'VALUE_ID'
,p_display_column_name=>'VALUE'
,p_default_sort_column_name=>'VALUE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
