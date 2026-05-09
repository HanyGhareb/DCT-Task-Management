prompt --application/shared_components/user_interface/lovs/organizations_with_cost_center_all_lov
begin
--   Manifest
--     ORGANIZATIONS WITH COST CENTER- ALL LOV
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
 p_id=>wwv_flow_api.id(36637578186702701)
,p_lov_name=>'ORGANIZATIONS WITH COST CENTER- ALL LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select nvl(org_name_en_user ,org_name_en ) org_name',
'        , org_id',
'        , cost_center_code ',
' from dct_hr_organizations;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ORG_ID'
,p_display_column_name=>'ORG_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'ORG_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(36638051381698885)
,p_query_column_name=>'ORG_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(36638459012698884)
,p_query_column_name=>'ORG_NAME'
,p_heading=>'Organization'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(36638843225698884)
,p_query_column_name=>'COST_CENTER_CODE'
,p_heading=>'Cost Center'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
