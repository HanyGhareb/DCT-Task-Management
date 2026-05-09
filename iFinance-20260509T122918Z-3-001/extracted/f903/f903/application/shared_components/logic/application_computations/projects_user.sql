prompt --application/shared_components/logic/application_computations/projects_user
begin
--   Manifest
--     APPLICATION COMPUTATION: PROJECTS_USER
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(77159164873026706)
,p_computation_sequence=>10
,p_computation_item=>'PROJECTS_USER'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  count(*)',
'FROM   btf_data_access',
'WHERE btf_data_access.entity_type = ''PROJECT''',
'and btf_data_access.user_id = :APP_USER'))
,p_computation_error_message=>'error in Projects User (App Item)'
,p_security_scheme=>wwv_flow_api.id(76610535612322773)
);
wwv_flow_api.component_end;
end;
/
