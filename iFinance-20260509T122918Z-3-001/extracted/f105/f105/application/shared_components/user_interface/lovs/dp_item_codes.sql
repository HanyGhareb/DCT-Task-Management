prompt --application/shared_components/user_interface/lovs/dp_item_codes
begin
--   Manifest
--     DP ITEM CODES
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
 p_id=>wwv_flow_api.id(58378763409383394)
,p_lov_name=>'DP ITEM CODES'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_ITEM_CODE , item_id',
'from dp_items'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ITEM_ID'
,p_display_column_name=>'DP_ITEM_CODE'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'DP_ITEM_CODE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(58378051178370264)
,p_query_column_name=>'DP_ITEM_CODE'
,p_heading=>'Dp Item Code'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
