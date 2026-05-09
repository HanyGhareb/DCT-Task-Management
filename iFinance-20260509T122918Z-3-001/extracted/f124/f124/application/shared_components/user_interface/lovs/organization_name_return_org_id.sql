prompt --application/shared_components/user_interface/lovs/organization_name_return_org_id
begin
--   Manifest
--     ORGANIZATION NAME RETURN ORG_ID
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(128341292413489799)
,p_lov_name=>'ORGANIZATION NAME RETURN ORG_ID'
,p_reference_id=>214471556378449782
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'ORGANIZATIONS_DETAILS_V'
,p_return_column_name=>'ORG_ID'
,p_display_column_name=>'ORG_NAME'
,p_default_sort_column_name=>'ORG_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
