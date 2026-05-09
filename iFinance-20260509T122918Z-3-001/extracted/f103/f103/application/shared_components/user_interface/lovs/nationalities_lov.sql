prompt --application/shared_components/user_interface/lovs/nationalities_lov
begin
--   Manifest
--     NATIONALITIES LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(34273852203859543)
,p_lov_name=>'NATIONALITIES LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_e_user ,desc_e) nationality_name_en , code nationality_code  ',
'from dct_employees_lookups',
'where lookup_number = 1;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'NATIONALITY_CODE'
,p_display_column_name=>'NATIONALITY_NAME_EN'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'NATIONALITY_NAME_EN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(34274353809855296)
,p_query_column_name=>'NATIONALITY_CODE'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(34274735446855296)
,p_query_column_name=>'NATIONALITY_NAME_EN'
,p_heading=>'Nationality Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
