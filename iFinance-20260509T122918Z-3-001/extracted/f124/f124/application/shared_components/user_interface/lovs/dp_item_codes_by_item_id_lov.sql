prompt --application/shared_components/user_interface/lovs/dp_item_codes_by_item_id_lov
begin
--   Manifest
--     DP ITEM CODES BY ITEM_ID LOV
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
 p_id=>wwv_flow_api.id(11791013955871785)
,p_lov_name=>'DP ITEM CODES BY ITEM_ID LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select dp_item_code, item_id',
'from dp_items'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ITEM_ID'
,p_display_column_name=>'DP_ITEM_CODE'
,p_default_sort_column_name=>'DP_ITEM_CODE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
