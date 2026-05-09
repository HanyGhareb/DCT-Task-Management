prompt --application/shared_components/user_interface/lovs/priority_lov
begin
--   Manifest
--     PRIORITY LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(48255921784526)
,p_lov_name=>'PRIORITY LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'VALUE_ID'
,p_display_column_name=>'VALUE'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'VALUE_ID'
,p_default_sort_direction=>'DESC'
);
wwv_flow_api.component_end;
end;
/
