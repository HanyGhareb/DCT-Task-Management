prompt --application/shared_components/user_interface/lovs/data_points_all_lov
begin
--   Manifest
--     DATA POINTS ALL LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(139681769223631976)
,p_lov_name=>'DATA POINTS ALL LOV'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'DP_SCOPE_DATA_POINTS'
,p_return_column_name=>'DATA_POINT_ID'
,p_display_column_name=>'DATA_POINT_NAME'
,p_default_sort_column_name=>'DATA_POINT_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
