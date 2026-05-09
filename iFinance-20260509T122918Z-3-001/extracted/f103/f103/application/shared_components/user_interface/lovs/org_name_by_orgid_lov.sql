prompt --application/shared_components/user_interface/lovs/org_name_by_orgid_lov
begin
--   Manifest
--     ORG NAME BY ORGID LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(24146367401244788)
,p_lov_name=>'ORG NAME BY ORGID LOV'
,p_reference_id=>43161732516701443
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select org_name , org_id',
'from organizations_details_v'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ORG_ID'
,p_display_column_name=>'ORG_NAME'
,p_default_sort_column_name=>'ORG_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
