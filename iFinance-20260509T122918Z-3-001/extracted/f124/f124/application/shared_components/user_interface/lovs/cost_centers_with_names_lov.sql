prompt --application/shared_components/user_interface/lovs/cost_centers_with_names_lov
begin
--   Manifest
--     COST CENTERS WITH NAMES LOV
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
 p_id=>wwv_flow_api.id(129457052659370368)
,p_lov_name=>'COST CENTERS WITH NAMES LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COST_CENTER_CODE || ''('' || COST_CENTER_DESCRIPTION || '')'' display, COST_CENTER_CODE',
'from( ',
'select DISTINCT COST_CENTER_CODE , COST_CENTER_DESCRIPTION ',
'from dct_gl_code_combinations_all);'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'COST_CENTER_CODE'
,p_display_column_name=>'DISPLAY'
,p_default_sort_column_name=>'DISPLAY'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
