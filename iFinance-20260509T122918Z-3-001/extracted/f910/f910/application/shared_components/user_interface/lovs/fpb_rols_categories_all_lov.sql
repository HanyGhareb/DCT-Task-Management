prompt --application/shared_components/user_interface/lovs/fpb_rols_categories_all_lov
begin
--   Manifest
--     FPB_ROLS_CATEGORIES_ALL_LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>40620729557075005
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(4494788551483708)
,p_lov_name=>'FPB_ROLS_CATEGORIES_ALL_LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value  , value_id',
'from dct_lookup_values',
'where lookup_id = (select l.lookup_id',
'                    from dct_lookups l',
'                    where l.lookup_code = ''RMC'')'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'VALUE_ID'
,p_display_column_name=>'VALUE'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'VALUE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
