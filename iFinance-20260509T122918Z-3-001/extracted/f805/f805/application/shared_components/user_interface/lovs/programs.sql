prompt --application/shared_components/user_interface/lovs/programs
begin
--   Manifest
--     PROGRAMS
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
 p_id=>wwv_flow_api.id(181740034893868397)
,p_lov_name=>'PROGRAMS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROGRAM_CODE , ID, OBJECTIVE_ID  , PROGRAM_NAME ',
'from strategic_objective_programs'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ID'
,p_display_column_name=>'PROGRAM_CODE'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(181740819615868398)
,p_query_column_name=>'ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(181741646639868398)
,p_query_column_name=>'PROGRAM_CODE'
,p_heading=>'Program Code'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(181741267241868398)
,p_query_column_name=>'PROGRAM_NAME'
,p_heading=>'Program Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(181740459443868397)
,p_query_column_name=>'OBJECTIVE_ID'
,p_heading=>'Objective Id'
,p_display_sequence=>30
,p_data_type=>'NUMBER'
);
wwv_flow_api.component_end;
end;
/
