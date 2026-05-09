prompt --application/shared_components/user_interface/lovs/countries_lov
begin
--   Manifest
--     COUNTRIES LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(110195700317850373)
,p_lov_name=>'COUNTRIES LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  SHORT_NAME, CODE , ABOVE_10HR_YN',
'from countries;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'CODE'
,p_display_column_name=>'SHORT_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'SHORT_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(110371569477116316)
,p_query_column_name=>'CODE'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(110371917142116316)
,p_query_column_name=>'SHORT_NAME'
,p_heading=>'Short Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(110372395130116315)
,p_query_column_name=>'ABOVE_10HR_YN'
,p_heading=>'Above 10hr Yn'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
,p_is_searchable=>'N'
);
wwv_flow_api.component_end;
end;
/
