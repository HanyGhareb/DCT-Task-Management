prompt --application/shared_components/user_interface/lovs/sectors_lov
begin
--   Manifest
--     SECTORS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>910
,p_default_id_offset=>82649548957193263
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(2484225145271400)
,p_lov_name=>'SECTORS LOV'
,p_lov_query=>'Select sector_id , sector_name from dct_hr_sectors_v;'
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'SECTOR_ID'
,p_display_column_name=>'SECTOR_NAME'
,p_default_sort_column_name=>'SECTOR_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
