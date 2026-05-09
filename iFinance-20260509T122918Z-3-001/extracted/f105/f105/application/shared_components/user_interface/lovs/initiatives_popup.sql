prompt --application/shared_components/user_interface/lovs/initiatives_popup
begin
--   Manifest
--     INITIATIVES POPUP
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(916102580051005)
,p_lov_name=>'INITIATIVES POPUP'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select INITIATIVE_ID, INITIATIVE_CODE, INITIATIVE_NAME, ',
'    decode(INITIATIVE_TYPE, ''S'' , ''Strategic'' , ''N'', ''Non-Strategic'') INITIATIVE_TYPE',
'from strategic_initiatives;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'INITIATIVE_ID'
,p_display_column_name=>'INITIATIVE_CODE'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'INITIATIVE_CODE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(916635423054230)
,p_query_column_name=>'INITIATIVE_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(917002299054231)
,p_query_column_name=>'INITIATIVE_CODE'
,p_heading=>'Initiative Code'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(917469391054231)
,p_query_column_name=>'INITIATIVE_NAME'
,p_heading=>'Initiative Name'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(917816493054231)
,p_query_column_name=>'INITIATIVE_TYPE'
,p_heading=>'Initiative Type'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
