prompt --application/shared_components/user_interface/lovs/departments_lov
begin
--   Manifest
--     DEPARTMENTS LOV
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
 p_id=>wwv_flow_api.id(36345980280462574)
,p_lov_name=>'DEPARTMENTS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select ORG_NAME Department , org_id',
'from organizations_details_v',
'where ORG_LEVEL = ''Department''',
'order by 1;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ORG_ID'
,p_display_column_name=>'DEPARTMENT'
);
wwv_flow_api.component_end;
end;
/
