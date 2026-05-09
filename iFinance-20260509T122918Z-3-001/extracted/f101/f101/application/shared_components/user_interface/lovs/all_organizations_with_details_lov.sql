prompt --application/shared_components/user_interface/lovs/all_organizations_with_details_lov
begin
--   Manifest
--     ALL ORGANIZATIONS WITH DETAILS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(3728040624112062)
,p_lov_name=>'ALL ORGANIZATIONS WITH DETAILS LOV'
,p_reference_id=>5591424056057518
,p_lov_query=>'select org_name ,  org_level , parent_org_name parent_org ,parent_level, department_name , sector , org_id from organizations_details_v'
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ORG_ID'
,p_display_column_name=>'ORG_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'ORG_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(3733368969112070)
,p_query_column_name=>'ORG_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(3733846283112070)
,p_query_column_name=>'ORG_NAME'
,p_heading=>'Organization'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(3734211912112070)
,p_query_column_name=>'ORG_LEVEL'
,p_heading=>'Level'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(3734589756112070)
,p_query_column_name=>'PARENT_ORG'
,p_heading=>'Parent Organization'
,p_display_sequence=>40
,p_data_type=>'NUMBER'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(3734987402112070)
,p_query_column_name=>'PARENT_LEVEL'
,p_heading=>'Parent Level'
,p_display_sequence=>50
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(3735387591112071)
,p_query_column_name=>'DEPARTMENT_NAME'
,p_heading=>'Department Name'
,p_display_sequence=>60
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(3735831788112071)
,p_query_column_name=>'SECTOR'
,p_heading=>'Sector'
,p_display_sequence=>70
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
