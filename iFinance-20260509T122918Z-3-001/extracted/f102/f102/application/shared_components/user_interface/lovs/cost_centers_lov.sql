prompt --application/shared_components/user_interface/lovs/cost_centers_lov
begin
--   Manifest
--     COST CENTERS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(34688749710635441)
,p_lov_name=>'COST CENTERS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct COST_CENTER_CODE ',
'    || ''('' || ',
'    COST_CENTER_DESCRIPTION',
'    || '')''  cc_name',
'    ,  COST_CENTER_CODE ',
'from dct_gl_code_combinations_all',
'order by 1;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_table=>'DCT_COST_CENTERS'
,p_return_column_name=>'COST_CENTER_CODE'
,p_display_column_name=>'CC_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
