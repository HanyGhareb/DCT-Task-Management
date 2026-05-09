prompt --application/shared_components/user_interface/lovs/purpose_eu_lov
begin
--   Manifest
--     PURPOSE EU LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(77115537704664606)
,p_lov_name=>'PURPOSE EU LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values'))
,p_source_type=>'LEGACY_SQL'
,p_location=>'LOCAL'
);
wwv_flow_api.component_end;
end;
/
