prompt --application/shared_components/user_interface/lovs/currency_lov
begin
--   Manifest
--     CURRENCY LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(25219591729855066)
,p_lov_name=>'CURRENCY LOV'
,p_reference_id=>19743961712092559
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value  d , value r',
'from dct_lookup_values',
'where lookup_id = 11'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'D'
,p_default_sort_column_name=>'D'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
