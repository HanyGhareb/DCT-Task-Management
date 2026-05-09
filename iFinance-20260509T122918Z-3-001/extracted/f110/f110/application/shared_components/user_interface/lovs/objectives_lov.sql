prompt --application/shared_components/user_interface/lovs/objectives_lov
begin
--   Manifest
--     OBJECTIVES LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>110
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(134304858382978398)
,p_lov_name=>'OBJECTIVES LOV'
,p_lov_query=>'select OBJECTIVE_CODE ,OBJECTIVE_ID  from strategic_objectives;'
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'OBJECTIVE_ID'
,p_display_column_name=>'OBJECTIVE_CODE'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'OBJECTIVE_CODE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(134305616258978398)
,p_query_column_name=>'OBJECTIVE_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(134305260861978398)
,p_query_column_name=>'OBJECTIVE_CODE'
,p_heading=>'Objective Code'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
