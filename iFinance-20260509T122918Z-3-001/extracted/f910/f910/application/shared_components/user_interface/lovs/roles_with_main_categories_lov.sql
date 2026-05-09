prompt --application/shared_components/user_interface/lovs/roles_with_main_categories_lov
begin
--   Manifest
--     ROLES WITH MAIN CATEGORIES LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>40620729557075005
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(4720878732497385)
,p_lov_name=>'ROLES WITH MAIN CATEGORIES LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  role_id  , role_name   as role_name , ',
'         (select l.value',
'                                from dct_lookup_values l',
'                                where l.value_id = roles.main_category)  Category ',
'from roles;',
'',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ROLE_ID'
,p_display_column_name=>'ROLE_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'ROLE_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(4721378104501133)
,p_query_column_name=>'CATEGORY'
,p_heading=>'Category'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(4724246518584745)
,p_query_column_name=>'ROLE_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(4721778005501133)
,p_query_column_name=>'ROLE_NAME'
,p_heading=>'Role Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
