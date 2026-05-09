prompt --application/shared_components/user_interface/lovs/dp_procurement_method_all
begin
--   Manifest
--     DP PROCUREMENT METHOD-ALL
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
 p_id=>wwv_flow_api.id(502791478764956231)
,p_lov_name=>'DP PROCUREMENT METHOD-ALL'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select TENDER_TYPE , ID',
' from DP_PROCUREMENT_METHOD'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ID'
,p_display_column_name=>'TENDER_TYPE'
,p_default_sort_column_name=>'TENDER_TYPE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
