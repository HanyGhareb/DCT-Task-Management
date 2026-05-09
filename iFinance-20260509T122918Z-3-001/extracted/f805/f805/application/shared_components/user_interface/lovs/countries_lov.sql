prompt --application/shared_components/user_interface/lovs/countries_lov
begin
--   Manifest
--     COUNTRIES LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(36341444582600574)
,p_lov_name=>'COUNTRIES LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(DESC_E_USER ,DESC_E ) Country, nvl(DESC_A_USER ,DESC_A ) Country_ar, CODE r',
'from dct_employees_lookups',
'where LOOKUP_NUMBER = 1',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'COUNTRY'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'COUNTRY'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(36341939264596868)
,p_query_column_name=>'R'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(36342380872596868)
,p_query_column_name=>'COUNTRY'
,p_heading=>'Country'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(36342774625596868)
,p_query_column_name=>'COUNTRY_AR'
,p_heading=>unistr('\0627\0644\0628\0644\062F')
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
