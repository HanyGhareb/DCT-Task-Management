prompt --application/shared_components/user_interface/lovs/copy_of_app_pages_5_lov
begin
--   Manifest
--     COPY OF APP PAGES - 5 LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(5034976802776714)
,p_lov_name=>'COPY OF APP PAGES - 5 LOV'
,p_reference_id=>5032210660748578
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PAGE_NAME , PAGE_ID',
'from apex_application_pages',
'where WORKSPACE = ''PROD'' and APPLICATION_ID = :P5_APP_ID'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PAGE_ID'
,p_display_column_name=>'PAGE_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'PAGE_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(5036807077776720)
,p_query_column_name=>'PAGE_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(5037203047776720)
,p_query_column_name=>'PAGE_NAME'
,p_heading=>'Page Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
