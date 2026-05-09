prompt --application/shared_components/user_interface/lovs/contract_by_project_page_24
begin
--   Manifest
--     CONTRACT BY PROJECT PAGE 24
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(98061996241659600)
,p_lov_name=>'CONTRACT BY PROJECT PAGE 24'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select cp.CONTRACT_NUMBER , cp.contract_number               ||',
'                            '' (''                             ||',
'                            NVL(c.contract_reference, ''XXX'') ||',
'                            '')''     contract',
'from cwip_contract_projects cp , cwip_contract c',
'where cp.contract_number = c.contract_number',
'and cp.project_number = :P24_PROJECT_NUMBER',
'order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'CONTRACT_NUMBER'
,p_display_column_name=>'CONTRACT'
);
wwv_flow_api.component_end;
end;
/
