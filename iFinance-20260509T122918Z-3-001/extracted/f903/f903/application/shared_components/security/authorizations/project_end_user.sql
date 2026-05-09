prompt --application/shared_components/security/authorizations/project_end_user
begin
--   Manifest
--     SECURITY SCHEME: Project End User
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_security_scheme(
 p_id=>wwv_flow_api.id(76610535612322773)
,p_name=>'Project End User'
,p_scheme_type=>'NATIVE_IS_IN_GROUP'
,p_attribute_01=>'Project End User'
,p_attribute_02=>'A'
,p_error_message=>'Only for Project End User Role.'
,p_caching=>'BY_USER_BY_SESSION'
);
wwv_flow_api.component_end;
end;
/
