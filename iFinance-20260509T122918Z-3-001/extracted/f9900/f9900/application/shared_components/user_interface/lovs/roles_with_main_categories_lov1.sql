prompt --application/shared_components/user_interface/lovs/roles_with_main_categories_lov1
begin
--   Manifest
--     ROLES WITH MAIN CATEGORIES LOV1
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
 p_id=>wwv_flow_api.id(40028295967835758)
,p_lov_name=>'ROLES WITH MAIN CATEGORIES LOV1'
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
 p_id=>wwv_flow_api.id(40027863660835758)
,p_query_column_name=>'CATEGORY'
,p_heading=>'Category'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(40027533240835758)
,p_query_column_name=>'ROLE_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(40027100869835758)
,p_query_column_name=>'ROLE_NAME'
,p_heading=>'Role Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
