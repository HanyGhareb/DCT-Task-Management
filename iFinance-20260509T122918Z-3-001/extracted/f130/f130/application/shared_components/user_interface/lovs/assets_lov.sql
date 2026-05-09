prompt --application/shared_components/user_interface/lovs/assets_lov
begin
--   Manifest
--     ASSETS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(95566805590894791)
,p_lov_name=>'ASSETS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ASSET_NUMBER, ASSET_ID,  TAG_NUMBER, DESCRIPTION',
'from fa_assets'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_table=>'FA_ASSETS'
,p_return_column_name=>'ASSET_ID'
,p_display_column_name=>'ASSET_NUMBER'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'ASSET_NUMBER'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(95567405827881048)
,p_query_column_name=>'ASSET_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(95567798937881048)
,p_query_column_name=>'ASSET_NUMBER'
,p_heading=>'Asset Number'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(95568195224881048)
,p_query_column_name=>'TAG_NUMBER'
,p_heading=>'Tag Number'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(95568569557881047)
,p_query_column_name=>'DESCRIPTION'
,p_heading=>'Description'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
