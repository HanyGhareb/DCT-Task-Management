prompt --application/shared_components/user_interface/lovs/new_assets_lov
begin
--   Manifest
--     NEW ASSETS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>110
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(134295736176030684)
,p_lov_name=>'NEW ASSETS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT NEW_ASSETS d, NEW_ASSETS r',
'from BUDGET'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'D'
,p_display_column_name=>'R'
,p_default_sort_column_name=>'R'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
